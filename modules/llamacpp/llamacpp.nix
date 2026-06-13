{
  lib,
  pkgs,
  pkgsUnstable,
  userName,
  ...
}:

let
  server = {
    apiKey = "ollama-local";
    host = "0.0.0.0";
    port = 11435;
    primaryModel = "ollama/qwen2.5-vl:7b";
  };

  models = [
    {
      id = "ollama/qwen3.5:9b";
      fileName = "Qwen_Qwen3.5-9B-Q6_K_L.gguf";
      url = "https://huggingface.co/bartowski/Qwen_Qwen3.5-9B-GGUF/resolve/main/Qwen_Qwen3.5-9B-Q6_K_L.gguf";
      ctxSize = 196608;
    }
    {
      id = "ollama/qwen3-vl:30b-a3b";
      fileName = "Qwen3VL-30B-A3B-Instruct-Q4_K_M.gguf";
      url = "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Instruct-GGUF/resolve/main/Qwen3VL-30B-A3B-Instruct-Q4_K_M.gguf";
      mmprojFileName = "mmproj-Qwen3VL-30B-A3B-Instruct-Q8_0.gguf";
      mmprojUrl = "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Instruct-GGUF/resolve/main/mmproj-Qwen3VL-30B-A3B-Instruct-Q8_0.gguf";
      ctxSize = 32768;
      extraArgs = [
        "--cache-type-k q8_0"
        "--cache-type-v q8_0"
      ];
    }
    {
      id = "ollama/qwen2.5-vl:7b";
      fileName = "Qwen2.5-VL-7B-Instruct-Q5_K_M.gguf";
      url = "https://huggingface.co/second-state/Qwen2.5-VL-7B-Instruct-GGUF/resolve/main/Qwen2.5-VL-7B-Instruct-Q5_K_M.gguf";
      mmprojFileName = "Qwen2.5-VL-7B-Instruct-vision.gguf";
      mmprojUrl = "https://huggingface.co/second-state/Qwen2.5-VL-7B-Instruct-GGUF/resolve/main/Qwen2.5-VL-7B-Instruct-vision.gguf";
      ctxSize = 196608;
    }
    {
      id = "ollama/gemma4:12b";
      fileName = "gemma-4-12b-it-Q4_K_M.gguf";
      url = "https://huggingface.co/unsloth/gemma-4-12b-it-GGUF/resolve/main/gemma-4-12b-it-Q4_K_M.gguf";
      mmprojFileName = "mmproj-F16.gguf";
      mmprojUrl = "https://huggingface.co/unsloth/gemma-4-12b-it-GGUF/resolve/main/mmproj-F16.gguf";
      ctxSize = 262144;
    }
  ];

  configDir = "/home/${userName}/.config/llamacpp";
  modelDir = "${configDir}/models";
  llamaCpp = pkgsUnstable.llama-cpp.override {
    blasSupport = false;
    vulkanSupport = true;
  };
  primaryModel = lib.findFirst (model: model.id == server.primaryModel) (builtins.head models) models;
  modelPath = "${modelDir}/${primaryModel.fileName}";
  mmprojPath = lib.optionalString (
    primaryModel ? mmprojFileName
  ) "${modelDir}/${primaryModel.mmprojFileName}";
  fetchJobs = lib.concatMap (
    model:
    [
      {
        id = model.id;
        fileName = model.fileName;
        url = model.url;
      }
    ]
    ++ lib.optional (model ? mmprojFileName && model ? mmprojUrl) {
      id = "${model.id} mmproj";
      fileName = model.mmprojFileName;
      url = model.mmprojUrl;
    }
  ) models;
  fetchModelShell = builtins.readFile ./fetch-model.sh;
  fetchModelsScript = pkgs.writeShellScriptBin "llm-fetch-models" ''
    set -euo pipefail
    CURL_BIN=${lib.escapeShellArg "${pkgs.curl}/bin/curl"}

    ${fetchModelShell}

    mkdir -p ${lib.escapeShellArg modelDir}
    ${lib.concatMapStringsSep "\n" (
      job:
      let
        target = "${modelDir}/${job.fileName}";
        etagFile = "${target}.etag";
        tmpTarget = "${modelDir}/.${job.fileName}.tmp";
        tmpEtagFile = "${etagFile}.tmp";
      in
      ''
        fetch_model \
          ${lib.escapeShellArg job.id} \
          ${lib.escapeShellArg target} \
          ${lib.escapeShellArg etagFile} \
          ${lib.escapeShellArg tmpTarget} \
          ${lib.escapeShellArg tmpEtagFile} \
          ${lib.escapeShellArg job.url}
      ''
    ) fetchJobs}
  '';
in
{
  imports = [
    ./mcp/application-tracking.nix
    ./mcp/memory-service.nix
    ./mcp/mikrotik.nix
    ./mcp/paperless.nix
    ./mcp/pihole.nix
    ./mcp/sequential-thinking.nix
  ];

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

    serviceConfig = {
      ExecStartPre = [
        "${pkgs.coreutils}/bin/test -s ${lib.escapeShellArg modelPath}"
      ]
      ++ lib.optional (
        primaryModel ? mmprojFileName
      ) "${pkgs.coreutils}/bin/test -s ${lib.escapeShellArg mmprojPath}";
      ExecStart = lib.concatStringsSep " " (
        [
          "${llamaCpp}/bin/llama-server"
          "--host ${server.host}"
          "--port ${toString server.port}"
          "--api-key ${lib.escapeShellArg server.apiKey}"
          "--model ${lib.escapeShellArg modelPath}"
          "--alias ${lib.escapeShellArg primaryModel.id}"
          "--ctx-size ${toString primaryModel.ctxSize}"
          "--n-gpu-layers 99"
        ]
        ++ lib.optional (primaryModel ? mmprojFileName) "--mmproj ${lib.escapeShellArg mmprojPath}"
        ++ (primaryModel.extraArgs or [ ])
        ++ [
          "--metrics"
          "--webui-mcp-proxy"
        ]
      );
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
