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
      llm-on = "ollama-start";
      llm-off = "ollama-stop";
      llm-log = "journalctl -u podman-ollama -f -o cat";
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

      autoload -Uz bracketed-paste-magic
      zle -N bracketed-paste bracketed-paste-magic

      ollama-start() {
        if sudo systemctl start podman-ollama.service podman-open-webui.service; then
          ${pkgs.libnotify}/bin/notify-send "Ollama" "Stack started"
        else
          ${pkgs.libnotify}/bin/notify-send --urgency=critical "Ollama" "Failed to start stack"
          return 1
        fi
      }

      ollama-stop() {
        if sudo systemctl stop podman-open-webui.service podman-ollama.service; then
          ${pkgs.libnotify}/bin/notify-send "Ollama" "Stack stopped"
        else
          ${pkgs.libnotify}/bin/notify-send --urgency=critical "Ollama" "Failed to stop stack"
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
