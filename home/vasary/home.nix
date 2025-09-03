{ config, pkgs, ... }:

{
  home = {
    username = "vasary";
    homeDirectory = "/home/vasary";
    stateVersion = "25.05";
    packages = with pkgs; [
      git
      curl
      wget
      jq
      yq
      docker-compose
      helm
      kubectl
      helmfile
      talosctl
      werf
      direnv
      nixfmt-rfc-style
      jetbrains.idea-community-bin
      jetbrains-mono
      nerd-fonts.jetbrains-mono
#      jetbrains.datagrip/
#      jetbrains.phpstorm//
      jetbrains.jdk
      telegram-desktop
      nixfmt-rfc-style
    ];
  };

  programs = {
    git = {
      enable = true;
      userName = "Viktor Gievoi";
      userEmail = "gievoi.v@gmail.com";
      extraConfig = {
        pull.rebase = true;
        merge.ff = "only";
        init.defaultBranch = "main";
        push.default = "current";
        color.ui = "auto";
        core.autocrlf = "input";
        fetch.prune = true;
        rebase.autoStash = true;
      };
    };

    zsh = {
      enable = true;
      autocd = true;

      shellAliases = {
        k = "kubectl";
      };

      history = {
        append = true;
        extended = true;
        ignoreAllDups = true;
      };

      syntaxHighlighting = {
        enable = true;
      };
    };
  };
}
