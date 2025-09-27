{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/boot.nix
    ../../modules/nix.nix
    ../../modules/virtualisation.nix
    ../../modules/llm.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    ../../modules/no-sleep.nix
    ../../modules/timezone.nix
    ../../modules/games.nix
    ../../modules/cfv3-resolved.nix
    ../../modules/nvidia.nix
    ../../modules/pipewire.nix
    ../../modules/xdg-portal.nix
    ../../modules/security.nix
    ../../modules/autologin.nix
    ../../modules/bluetooth.nix
    ../../modules/frimware.nix
    ../../modules/printing.nix
    ../../modules/printer/xerox3020/printer.nix
    ../../modules/mount/warehouse.nix
    ../../modules/mount/music.nix
    ../../modules/mount/projects.nix
    ./hardware-configuration.nix
  ];

  boot.extraModprobeConfig = ''
    options mt7921e disable_aspm=1
  '';

  networking = {
    hostName = "workstation";
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
      };
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.05";
}
