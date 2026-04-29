{
  lib,
  pkgs,
  userName,
  ...
}:

let
  manifest = import ./manifest.nix;
  configDir = "/home/${userName}/.config/llamacpp";
  modelDir = "${configDir}/models";
  llamaCpp = pkgs.llama-cpp.override {
    blasSupport = false;
    vulkanSupport = true;
  };
  primaryModel = lib.findFirst (
    model: model.id == manifest.primaryModel
  ) (builtins.head manifest.models) manifest.models;
  modelPath = "${modelDir}/${primaryModel.fileName}";
  fetchModelsScript = lib.concatMapStringsSep "\n" (
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
  ) manifest.models;
in
{
  environment.systemPackages = [
    llamaCpp
  ];

  networking.firewall.allowedTCPPorts = [
    manifest.port
  ];

  systemd.tmpfiles.rules = [
    "d ${configDir} 0755 ${userName} users - -"
    "d ${modelDir} 0755 ${userName} users - -"
  ];

  systemd.services.llamacpp-fetch-models = {
    description = "Download llama.cpp GGUF models";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    script = ''
      mkdir -p ${lib.escapeShellArg modelDir}
      ${fetchModelsScript}
    '';

    serviceConfig = {
      Type = "oneshot";
      User = userName;
      Group = "users";
      WorkingDirectory = configDir;
    };
  };

  systemd.services.llamacpp = {
    description = "llama.cpp OpenAI-compatible server";
    after = [
      "network-online.target"
      "llamacpp-fetch-models.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "llamacpp-fetch-models.service" ];

    environment = {
      LLAMA_API_KEY = manifest.apiKey;
    };

    serviceConfig = {
      ExecStart = lib.concatStringsSep " " [
        "${llamaCpp}/bin/llama-server"
        "--host ${manifest.host}"
        "--port ${toString manifest.port}"
        "--api-key ${lib.escapeShellArg manifest.apiKey}"
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
