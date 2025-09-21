{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:main";
    ports = [ "3000:8080" ];
    volumes = [ "open-webui:/app/backend/data" ];
    extraOptions = [ "--network=host" ];
    autoStart = true;
    environment = {
      WEBUI_AUTH = "false";
      WEBUI_NAME = "LLM @ Home";
    };
  };
}
