{ pkgs, ... }:

{
  home.packages = [
    pkgs.git
  ];

  home.file.".config/git/ignore".text = ''
    .idea/
    .vscode/
    .direnv/
  '';

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
        core.excludesFile = "~/.config/git/ignore";
      };
    };
  };
}
