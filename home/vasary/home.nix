{ config, pkgs, ... }:

{
  home = {
    username = "vasary";
    homeDirectory = "/home/vasary";
    stateVersion = "25.05";
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
