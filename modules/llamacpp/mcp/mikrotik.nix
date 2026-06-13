{ config, pkgs, ... }:

let
  mikrotikMcpImage = "localhost/llamacpp-mcp-mikrotik";
in
{
  systemd.services.podman-build-llamacpp-mcp-mikrotik-image = {
    description = "Build the MikroTik MCP container image";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "podman-mcp-mikrotik.service" ];
    path = [ pkgs.git ];

    script = ''
      ${config.virtualisation.podman.package}/bin/podman build \
        --tag ${mikrotikMcpImage} \
        https://github.com/jeff-nasseri/mikrotik-mcp.git
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.podman-mcp-mikrotik = {
    requires = [ "podman-build-llamacpp-mcp-mikrotik-image.service" ];
    after = [ "podman-build-llamacpp-mcp-mikrotik-image.service" ];
  };

  virtualisation.oci-containers.containers.mcp-mikrotik = {
    image = mikrotikMcpImage;
    autoStart = true;
    networks = [ "podman" ];
    ports = [ "3105:8000" ];
    cmd = [
      "python"
      "-c"
      ''
        import uvicorn
        from starlette.middleware.cors import CORSMiddleware
        from mcp_mikrotik import config
        from mcp_mikrotik.app import mcp
        from mcp_mikrotik.config import MikrotikConfig

        config.mikrotik_config = MikrotikConfig(_cli_parse_args=True)
        mcp.settings.host = config.mikrotik_config.mcp.host
        mcp.settings.port = config.mikrotik_config.mcp.port

        app = mcp.streamable_http_app()
        app.add_middleware(
          CORSMiddleware,
          allow_origins=["*"],
          allow_methods=["GET", "POST", "DELETE", "OPTIONS"],
          allow_headers=["*"],
          expose_headers=["Mcp-Session-Id", "mcp-session-id"],
        )

        uvicorn.run(app, host=mcp.settings.host, port=mcp.settings.port)
      ''
    ];
    environment = {
      MIKROTIK_MCP__TRANSPORT = "streamable-http";
      MIKROTIK_MCP__HOST = "0.0.0.0";
      MIKROTIK_MCP__PORT = "8000";
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-mikrotik"
    ];
  };
}
