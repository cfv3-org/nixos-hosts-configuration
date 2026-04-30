{ ... }:

{
  virtualisation.oci-containers.containers.ollama = {
    image = "ollama/ollama:0.21.1-rocm";
    autoStart = true;
    ports = [ "11434:11434" ];
    volumes = [ "ollama:/root/.ollama" ];
    environment = {
      OLLAMA_HOST = "0.0.0.0:11434";
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_KEEP_ALIVE = "15m";
    };
    extraOptions = [
      "--device=/dev/kfd"
      "--device=/dev/dri"
      "--group-add=video"
      "--network=host"
    ];
  };

  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:v0.8.12";
    autoStart = true;
    ports = [ "3000:8080" ];
    volumes = [ "open-webui:/app/backend/data" ];
    environment = {
      ENABLE_OLLAMA_API = "True";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      WEBUI_AUTH = "False";
      WEBUI_NAME = "LLM @ Home";
    };
    extraOptions = [
      "--network=host"
    ];
  };
}
