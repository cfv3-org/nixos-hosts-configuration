{ pkgs, ... }:

{
  virtualisation.oci-containers.containers.ollama = {
    image = "ollama/ollama:latest";
    autoStart = true;
    ports = [ "11434:11434" ];
    volumes = [ "ollama:/root/.ollama" ];
    extraOptions = [
      "--device=/dev/kfd"
      "--device=/dev/dri"
      "--group-add=video"
      "--network=host"
    ];
    environment = {
      HSA_OVERRIDE_GFX_VERSION = "12.0.1";
      OLLAMA_DEBUG = "1";
    };
  };

  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:main";
    ports = [ "3000:8080" ];
    volumes = [ "open-webui:/app/backend/data" ];
    extraOptions = [ "--network=host" ];
    autoStart = true;
    environment = {
      ENABLE_OLLAMA_API = "True";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      WEBUI_AUTH = "False";
      WEBUI_NAME = "LLM @ Home";
    };
  };
}
