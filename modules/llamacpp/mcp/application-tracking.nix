{ ... }:

{
  virtualisation.oci-containers.containers.mcp-application-tracking = {
    image = "ghcr.io/vasary/js-mcp:sha-7eeb823";
    autoStart = true;
    networks = [ "podman" ];
    ports = [ "3103:3103" ];
    environment = {
      JOB_SEARCH_TRANSPORT = "streamable_http";
      JOB_SEARCH_HTTP_ADDR = ":3103";
      JOB_SEARCH_HTTP_ENDPOINT = "/mcp";
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-application-tracking"
    ];
  };
}
