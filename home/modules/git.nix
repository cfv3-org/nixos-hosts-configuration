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
      settings = {
        user = {
          name = "Viktor Gievoi";
          email = "gievoi.v@gmail.com";
        };
        pull.rebase = true;
        merge.ff = "only";
        init.defaultBranch = "master";
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
