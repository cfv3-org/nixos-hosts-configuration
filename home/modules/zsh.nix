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
