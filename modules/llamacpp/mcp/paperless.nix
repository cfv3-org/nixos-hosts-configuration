{
  config,
  pkgs,
  ...
}:

let
  paperlessMcpImage = "localhost/llamacpp-mcp-paperless";
  paperlessMcpDockerfile = pkgs.writeText "llamacpp-mcp-paperless.Dockerfile" ''
    FROM ghcr.io/freeformz/paperless-ngx-mcp:latest AS paperless-mcp

    FROM docker.io/library/node:22-alpine

    RUN npm install -g supergateway@3.4.3
    COPY --from=paperless-mcp /paperless-ngx-mcp /usr/local/bin/paperless-ngx-mcp
  '';
in
{
  systemd.services.podman-build-llamacpp-mcp-paperless-image = {
    description = "Build the Paperless MCP container image";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "podman-mcp-paperless.service" ];

    script = ''
      ${config.virtualisation.podman.package}/bin/podman build \
        --tag ${paperlessMcpImage} \
        --file ${paperlessMcpDockerfile} \
        /tmp
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.podman-mcp-paperless = {
    requires = [ "podman-build-llamacpp-mcp-paperless-image.service" ];
    after = [ "podman-build-llamacpp-mcp-paperless-image.service" ];
  };

  virtualisation.oci-containers.containers.mcp-paperless = {
    image = paperlessMcpImage;
    autoStart = true;
    networks = [ "podman" ];
    ports = [ "3101:3101" ];
    cmd = [
      "sh"
      "-c"
      "supergateway --stdio 'paperless-ngx-mcp mcp' --outputTransport streamableHttp --port 3101 --streamableHttpPath /mcp"
    ];
    environment = {
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-paperless"
    ];
  };
}
