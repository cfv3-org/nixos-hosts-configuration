{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.datagrip
    jetbrains.phpstorm
    jetbrains.goland
    jetbrains.webstorm

    direnv
    nix-direnv
    nixfmt-rfc-style

    pkgsUnstable.jetbrains.jdk
    pkgsUnstable.postman
    pkgsUnstable.insomnia
    pkgsUnstable.bruno
  ];

  xdg.configFile."JetBrainsPlugins/ide-eval-resetter-1.0.0.zip".source = ./jetbrains/trial-reset.zip;

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
