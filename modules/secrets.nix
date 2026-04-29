{
  config,
  pkgs,
  userName,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";

    secrets = {
      "openclaw/ollama_api_key" = { };
      "openclaw/gemini_api_key" = { };
      "openclaw/gateway_token" = { };
      "openclaw/goldapi_token" = { };
    };

    templates."openclaw.env".content = ''
      OLLAMA_API_KEY=${config.sops.placeholder."openclaw/ollama_api_key"}
      GEMINI_API_KEY=${config.sops.placeholder."openclaw/gemini_api_key"}
      GATEWAY_TOKEN=${config.sops.placeholder."openclaw/gateway_token"}
      OPENCLAW_GATEWAY_TOKEN=${config.sops.placeholder."openclaw/gateway_token"}
      GOLDAPI_TOKEN=${config.sops.placeholder."openclaw/goldapi_token"}
    '';
  };

  virtualisation.oci-containers.containers.openclaw.environmentFiles = [
    config.sops.templates."openclaw.env".path
  ];
}
