{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    autocd = true;

    shellAliases = {
      k = "kubectl";
      ll = "eza --icons=always -l";
      docker-compose = "podman-compose";
      llm-on = "llamacpp-start";
      llm-off = "llamacpp-stop";
      llm-log = "journalctl -u llamacpp -f -o cat";
      llm-fetch-models = "llm-fetch-models";
    };

    history = {
      append = true;
      extended = true;
      ignoreAllDups = true;
    };

    initContent = ''
      export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
      export OLLAMA_USE_GPU=1
      export OLLAMA_DEBUG=1
      eval "$(direnv hook zsh)"

      llamacpp-start() {
        if sudo systemctl start llamacpp.service; then
          ${pkgs.libnotify}/bin/notify-send "llama.cpp" "Server started"
        else
          ${pkgs.libnotify}/bin/notify-send --urgency=critical "llama.cpp" "Failed to start server"
          return 1
        fi
      }

      llamacpp-stop() {
        if sudo systemctl stop llamacpp.service; then
          ${pkgs.libnotify}/bin/notify-send "llama.cpp" "Server stopped"
        else
          ${pkgs.libnotify}/bin/notify-send --urgency=critical "llama.cpp" "Failed to stop server"
          return 1
        fi
      }
    '';

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
      ];
    };
  };
}
