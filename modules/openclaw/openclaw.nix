{
  config,
  pkgs,
  userName,
  ...
}:

let
  obsidian = {
    hostVaultPath = "/home/${userName}/obsidian/vault/tars";
    containerVaultPath = "/vaults/obsidian/tars";
  };

  obsidianMcpPort = 3102;
  obsidianMcpImage = "localhost/obsidian-mcp:2026-04-30";
  obsidianMcpDockerfile = pkgs.writeText "obsidian-mcp.Dockerfile" ''
    FROM docker.io/library/node:22-alpine
    RUN npm install -g \
      supergateway@3.4.3 \
      @modelcontextprotocol/server-filesystem@2026.1.14
    WORKDIR /app
    ENV NODE_ENV=production TZ=Europe/Berlin
    CMD supergateway \
      --stdio "mcp-server-filesystem ${obsidian.containerVaultPath}" \
      --outputTransport streamableHttp \
      --port ${toString obsidianMcpPort}
  '';

  openclawBaseImage = "ghcr.io/openclaw/openclaw:2026.4.29";
  openclawImage = "localhost/openclaw:2026.4.29-qmd-mcp";
  openclawDockerfile = pkgs.writeText "openclaw.Dockerfile" ''
    FROM ${openclawBaseImage}

    USER root
    RUN npm install -g \
      @tobilu/qmd@2.1.0 \
      @modelcontextprotocol/server-filesystem@2026.1.14 \
      @modelcontextprotocol/server-postgres@0.6.2 \
      obsidian-mcp-server@3.1.1 \
      @modelcontextprotocol/server-sequential-thinking@2025.12.18

    USER node
  '';

  gateway = {
    image = openclawImage;
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
      NPM_CONFIG_CACHE = "/home/node/.npm";
      NPM_CONFIG_PREFIX = "/home/node/.npm-global";
      NODE_PATH = "/home/node/.npm-global/lib/node_modules:/usr/local/lib/node_modules";
      PATH = "/home/node/.npm-global/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin";
      NVIDIA_VISIBLE_DEVICES = "void";
      OBSIDIAN_VAULT_PATH = obsidian.containerVaultPath;
      OBSIDIAN_MCP_URL = "http://obsidian-mcp:${toString obsidianMcpPort}/mcp";
      JOB_SEARCH_MCP_URL = "http://job-search-mcp:${toString jobSearchMcp.port}/mcp";
      LLAMACPP_BASE_URL = "http://host.containers.internal:11435/v1";
    };
  };

  obsidianMcp = {
    image = obsidianMcpImage;
    port = obsidianMcpPort;
    volumes = [
      "${obsidian.hostVaultPath}:${obsidian.containerVaultPath}"
    ];
  };

  jobSearchMcp = {
    image = "ghcr.io/vasary/js-mcp:sha-7eeb823";
    port = 3103;
    environment = {
      JOB_SEARCH_TRANSPORT = "streamable_http";
      JOB_SEARCH_HTTP_ADDR = ":${toString jobSearchMcp.port}";
      JOB_SEARCH_HTTP_ENDPOINT = "/mcp";
      TZ = "Europe/Berlin";
      JOB_SEARCH_DATABASE_URL = "postgres://openclaw:AHdzrYQ2KXVb@10.10.0.4:5432/box";
    };
  };
in
{
  systemd.services.podman-build-openclaw-image = {
    description = "Build the OpenClaw container image";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "podman-openclaw.service" ];

    script = ''
      ${config.virtualisation.podman.package}/bin/podman build \
        --tag ${openclawImage} \
        --file ${openclawDockerfile} \
        /tmp
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.podman-build-obsidian-mcp-image = {
    description = "Build the Obsidian MCP container image";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "podman-obsidian-mcp.service" ];

    script = ''
      if ! ${config.virtualisation.podman.package}/bin/podman image exists ${obsidianMcpImage}; then
        ${config.virtualisation.podman.package}/bin/podman build \
          --tag ${obsidianMcpImage} \
          --file ${obsidianMcpDockerfile} \
          /tmp
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.podman-openclaw = {
    requires = [ "podman-build-openclaw-image.service" ];
    after = [ "podman-build-openclaw-image.service" ];
  };

  systemd.services.podman-obsidian-mcp = {
    requires = [ "podman-build-obsidian-mcp-image.service" ];
    after = [ "podman-build-obsidian-mcp-image.service" ];
  };

  virtualisation.oci-containers.containers.openclaw = {
    image = gateway.image;
    autoStart = false;
    networks = [ "podman" ];
    ports = gateway.ports;
    volumes = gateway.volumes;
    cmd = gateway.cmd;
    environment = gateway.environment;
    extraOptions = [
      "--network-alias=openclaw"
    ];
  };

  virtualisation.oci-containers.containers.obsidian-mcp = {
    image = obsidianMcp.image;
    autoStart = false;
    networks = [ "podman" ];
    ports = [ "${toString obsidianMcp.port}:${toString obsidianMcp.port}" ];
    volumes = obsidianMcp.volumes;
    extraOptions = [
      "--network-alias=obsidian-mcp"
    ];
  };

  virtualisation.oci-containers.containers.job-search-mcp = {
    image = jobSearchMcp.image;
    autoStart = false;
    networks = [ "podman" ];
    ports = [ "${toString jobSearchMcp.port}:${toString jobSearchMcp.port}" ];
    environment = jobSearchMcp.environment;
    extraOptions = [
      "--network-alias=job-search-mcp"
    ];
  };
}
