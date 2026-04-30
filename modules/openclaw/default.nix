{ userName, ... }:

let
  obsidian = {
    hostVaultPath = "/home/${userName}/obsidian/vault/tars";
    containerVaultPath = "/vaults/obsidian/tars";
  };

  obsidianMcpPort = 3102;

  gateway = {
    image = "ghcr.io/openclaw/openclaw:2026.4.22";
    ports = [
      "18789:18789"
      "18793:18793"
    ];
    volumes = [
      "/home/${userName}/.openclaw:/home/node/.openclaw"
      "/home/${userName}/.config/openclaw/.npm:/home/node/.npm"
      "/home/${userName}/.config/openclaw/.npm-global:/home/node/.npm-global"
      "${obsidian.hostVaultPath}:${obsidian.containerVaultPath}"
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
      OBSIDIAN_VAULT_PATH = obsidian.containerVaultPath;
    };
  };

  obsidianMcp = {
    image = "node:22-alpine";
    port = obsidianMcpPort;
    volumes = [
      "${obsidian.hostVaultPath}:${obsidian.containerVaultPath}"
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
          --stdio "npx -y @modelcontextprotocol/server-filesystem ${obsidian.containerVaultPath}" \
          --outputTransport streamableHttp \
          --port ${toString obsidianMcpPort}
      ''
    ];
  };
in
{
  virtualisation.oci-containers.containers.openclaw = {
    image = gateway.image;
    autoStart = true;
    ports = gateway.ports;
    volumes = gateway.volumes;
    cmd = gateway.cmd;
    environment = gateway.environment;
    extraOptions = [
      "--network=host"
    ];
  };

  virtualisation.oci-containers.containers.obsidian-mcp = {
    image = obsidianMcp.image;
    autoStart = true;
    ports = [ "${toString obsidianMcp.port}:${toString obsidianMcp.port}" ];
    volumes = obsidianMcp.volumes;
    environment = obsidianMcp.environment;
    cmd = obsidianMcp.cmd;
    extraOptions = [
      "--network=host"
    ];
  };
}
