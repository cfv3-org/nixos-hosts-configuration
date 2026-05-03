{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  userName,
  ...
}:

{
  imports = [
    ../../modules/utils.nix
    ../../modules/k8s-utils.nix
    ../../modules/talos.nix
    ../../modules/communications.nix
    ../../modules/ide.nix
    ../../modules/development/cursor.nix
    ../../modules/development/go.nix
    ../../modules/development/node.nix
    ../../modules/development/rust.nix
    ../../modules/bitwarden.nix
    ../../modules/fonts.nix
    ../../modules/terminal.nix
    ../../modules/online-accounts.nix
    ../../modules/mailing.nix
    ../../modules/media.nix
    ../../modules/secrets.nix
    ../../modules/webcam.nix
    ../../modules/razer.nix
    ../../modules/gaming.nix
    ../../modules/git.nix
    ../../modules/wallpaper.nix
    ../../modules/zsh.nix
    ../../modules/chromium.nix
    ../../modules/firefox.nix
    ../../modules/gnome.nix
    ../../modules/office.nix
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = "25.05";
  };
}
