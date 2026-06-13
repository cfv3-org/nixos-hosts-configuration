{ ... }:

{
  systemd.services.podman-mcp-pihole-proxy = {
    requires = [ "podman-mcp-pihole.service" ];
    after = [ "podman-mcp-pihole.service" ];
  };

  virtualisation.oci-containers.containers.mcp-pihole = {
    image = "sbarbett/pihole-mcp-server:latest";
    autoStart = true;
    networks = [ "podman" ];
    environment = {
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-pihole"
    ];
  };

  virtualisation.oci-containers.containers.mcp-pihole-proxy = {
    image = "ghcr.io/supercorp-ai/supergateway:3.4.3";
    autoStart = true;
    networks = [ "podman" ];
    ports = [ "3100:3100" ];
    cmd = [
      "--stdio"
      "npx -y mcp-remote http://mcp-pihole:8000/sse --allow-http"
      "--outputTransport"
      "streamableHttp"
      "--port"
      "3100"
      "--streamableHttpPath"
      "/mcp"
    ];
    environment = {
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-pihole-proxy"
    ];
  };
}
