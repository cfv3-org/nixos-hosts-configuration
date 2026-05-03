{
  lib,
  pkgs,
  userName,
  ...
}:

let
  server = {
    apiKey = "ollama-local";
    host = "0.0.0.0";
    port = 11435;
    primaryModel = "ollama/qwen3.5:9b";
  };

  models = [
    {
      id = "ollama/qwen3.5:9b";
      fileName = "Qwen3.5-text-9B-Q4_K_M.gguf";
      url = "https://huggingface.co/techwithsergiu/Qwen3.5-text-9B-GGUF/resolve/main/Qwen3.5-text-9B-Q4_K_M.gguf";
      ctxSize = 8192;
    }
    {
      id = "ollama/gemma4:e4b";
      fileName = "gemma-4-E4B-it-Q4_K_M.gguf";
      url = "https://huggingface.co/unsloth/gemma-4-E4B-it-GGUF/resolve/main/gemma-4-E4B-it-Q4_K_M.gguf";
      ctxSize = 8192;
    }
  ];

  configDir = "/home/${userName}/.config/llamacpp";
  modelDir = "${configDir}/models";
  llamaCpp = pkgs.llama-cpp.override {
    blasSupport = false;
    vulkanSupport = true;
  };
  primaryModel = lib.findFirst (model: model.id == server.primaryModel) (builtins.head models) models;
  modelPath = "${modelDir}/${primaryModel.fileName}";
  fetchModelsScript = pkgs.writeShellScriptBin "llamacpp-fetch-models" ''
    set -euo pipefail
    mkdir -p ${lib.escapeShellArg modelDir}
    ${lib.concatMapStringsSep "\n" (
      model:
      let
        target = "${modelDir}/${model.fileName}";
      in
      ''
        if [ ! -s ${lib.escapeShellArg target} ]; then
          echo "Downloading ${model.id} to ${target}"
          ${pkgs.curl}/bin/curl \
            --location \
            --fail \
            --continue-at - \
            --output ${lib.escapeShellArg target} \
            ${lib.escapeShellArg model.url}
        fi
      ''
    ) models}
  '';
in
{
  environment.systemPackages = [
    llamaCpp
    fetchModelsScript
  ];

  networking.firewall.allowedTCPPorts = [
    server.port
  ];

  systemd.tmpfiles.rules = [
    "d ${configDir} 0755 ${userName} users - -"
    "d ${modelDir} 0755 ${userName} users - -"
  ];

  systemd.services.llamacpp = {
    description = "llama.cpp OpenAI-compatible server";
    after = [
      "network-online.target"
    ];
    wants = [ "network-online.target" ];

    environment = {
      LLAMA_API_KEY = server.apiKey;
    };

    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/test -s ${lib.escapeShellArg modelPath}";
      ExecStart = lib.concatStringsSep " " [
        "${llamaCpp}/bin/llama-server"
        "--host ${server.host}"
        "--port ${toString server.port}"
        "--api-key ${lib.escapeShellArg server.apiKey}"
        "--model ${lib.escapeShellArg modelPath}"
        "--alias ${lib.escapeShellArg primaryModel.id}"
        "--ctx-size ${toString primaryModel.ctxSize}"
        "--n-gpu-layers 99"
        "--metrics"
      ];
      Restart = "on-failure";
      User = userName;
      Group = "users";
      SupplementaryGroups = [
        "video"
        "render"
      ];
      WorkingDirectory = configDir;
    };
  };
}
