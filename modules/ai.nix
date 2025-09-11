{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    ollama
    open-webui
  ];

  services = {
    ollama = {
      enable = false;
      loadModels = [
        "codellama:7b-instruct-q4_1"
      ];
    };
    open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = 8080;
      environment = {
        ENABLE_OLLAMA_API = "True";
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
        WEBUI_AUTH = "False";
        WEBUI_NAME = "LLM @ Vasary home";
      };
    };
  };
}
