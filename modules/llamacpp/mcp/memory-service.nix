{ userName, ... }:

let
  dataDir = "/home/${userName}/.config/mcp/memory-service";
in
{
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${userName} users - -"
  ];

  virtualisation.oci-containers.containers.mcp-memory-service = {
    image = "ghcr.io/doobidoo/mcp-memory-service:latest";
    autoStart = true;
    networks = [ "podman" ];
    ports = [ "3102:8765" ];
    volumes = [
      "${dataDir}:/data"
    ];
    environment = {
      MCP_STREAMABLE_HTTP_MODE = "1";
      MCP_SSE_HOST = "0.0.0.0";
      MCP_SSE_PORT = "8765";
      MCP_OAUTH_ENABLED = "false";
      MCP_OAUTH_STORAGE_BACKEND = "sqlite";
      MCP_OAUTH_SQLITE_PATH = "/data/oauth.db";
      MCP_MEMORY_STORAGE_BACKEND = "sqlite_vec";
      MCP_MEMORY_SQLITE_PATH = "/data/sqlite_vec.db";
      MCP_MEMORY_SQLITE_PRAGMAS = "journal_mode=WAL,busy_timeout=15000";
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--network-alias=mcp-memory-service"
    ];
  };
}
