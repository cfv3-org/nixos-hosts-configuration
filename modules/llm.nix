{ pkgs, userName, ... }:

let
  obsidianVaultPath = "/home/${userName}/obsidian/vault/tars";
in
{

  networking.firewall.allowedTCPPorts = [ 11434 ];
  virtualisation.oci-containers.containers.ollama = {
    image = "ollama/ollama:0.21.1-rocm";
    autoStart = false;
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
    autoStart = false;
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

  virtualisation.oci-containers.containers.openclaw = {
    image = "ghcr.io/openclaw/openclaw:2026.4.22";
    autoStart = false;
    ports = [
      "18789:18789"
      "18793:18793"
    ];
    volumes = [
      "/home/${userName}/.openclaw:/home/node/.openclaw"
      "/home/${userName}/.config/openclaw/.npm:/home/node/.npm"
      "/home/${userName}/.config/openclaw/.npm-global:/home/node/.npm-global"
      "${obsidianVaultPath}:/vaults/obsidian/tars"
    ];
    cmd = [
      "openclaw"
      "gateway"
      "--allow-unconfigured"
    ];
    environment = {
      NODE_ENV = "production";
      TZ = "Europe/Berlin";
      HOME = "/home/node";
      NVIDIA_VISIBLE_DEVICES = "void";
      OBSIDIAN_VAULT_PATH = "/vaults/obsidian/tars";
    };
    extraOptions = [
      "--network=host"
    ];
  };

  virtualisation.oci-containers.containers.obsidian-mcp = {
    image = "node:22-alpine";
    autoStart = false;
    ports = [ "3102:3102" ];
    volumes = [
      "${obsidianVaultPath}:/vaults/obsidian/tars"
    ];
    environment = {
      NODE_ENV = "production";
      TZ = "Europe/Berlin";
    };
    cmd = [
      "sh"
      "-lc"
      ''
        npx -y supergateway \
          --stdio "npx -y @modelcontextprotocol/server-filesystem /vaults/obsidian/tars" \
          --outputTransport streamableHttp \
          --port 3102
      ''
    ];
    extraOptions = [
      "--network=host"
    ];
  };
}
