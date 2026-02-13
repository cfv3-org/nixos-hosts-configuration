{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.datagrip
    jetbrains.phpstorm
    jetbrains.goland
    jetbrains.webstorm
    jetbrains.rust-rover

    direnv
    nix-direnv
    nixfmt-rfc-style
    nixfmt-tree

    pkgsUnstable.jetbrains.jdk
    pkgsUnstable.postman

    (pkgs.callPackage ../packages/jb-cleanup { })
  ];

  programs = {
    vscode = {
      enable = true;
      package = pkgsUnstable.vscode;

      profiles.default = {
        extensions = with pkgsUnstable.vscode-extensions; [
          bmewburn.vscode-intelephense-client
          xdebug.php-debug
          yzhang.markdown-all-in-one
          davidanson.vscode-markdownlint
          jnoortheen.nix-ide
          rooveterinaryinc.roo-cline
          streetsidesoftware.code-spell-checker
        ];
      };
    };
  };
}
