{
  config,
  pkgs,
  ...
}:

let
  sequentialThinkingMcpImage = "localhost/llamacpp-mcp-sequential-thinking";
  sequentialThinkingMcpDockerfile = pkgs.writeText "llamacpp-mcp-sequential-thinking.Dockerfile" ''
    FROM docker.io/library/node:22-alpine

    RUN npm install -g supergateway@3.4.3
  '';
in
{
  systemd.services.podman-build-llamacpp-mcp-sequential-thinking-image = {
    description = "Build the Sequential Thinking MCP container image";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "podman-mcp-sequential-thinking.service" ];

    script = ''
      ${config.virtualisation.podman.package}/bin/podman build \
        --tag ${sequentialThinkingMcpImage} \
        --file ${sequentialThinkingMcpDockerfile} \
        /tmp
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.podman-mcp-sequential-thinking = {
    requires = [ "podman-build-llamacpp-mcp-sequential-thinking-image.service" ];
    after = [ "podman-build-llamacpp-mcp-sequential-thinking-image.service" ];
  };

  virtualisation.oci-containers.containers.mcp-sequential-thinking = {
    image = sequentialThinkingMcpImage;
    autoStart = true;
    networks = [ "podman" ];
    ports = [ "3104:3104" ];
    cmd = [
      "supergateway"
      "--stdio"
      "npx -y @modelcontextprotocol/server-sequential-thinking"
      "--outputTransport"
      "streamableHttp"
      "--port"
      "3104"
      "--streamableHttpPath"
      "/mcp"
      "--cors"
    ];
    environment = {
      DISABLE_THOUGHT_LOGGING = "true";
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-sequential-thinking"
    ];
  };
}
