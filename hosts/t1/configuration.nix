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
    ../../modules/users.nix
    ../../modules/i18n.nix
    ../../modules/no-sleep.nix
    ../../modules/timezone.nix
    ../../modules/cfv3-resolved.nix
    ../../modules/amd-gpu.nix
    ../../modules/llm.nix
    ../../modules/trusted.nix
    ../../modules/pipewire.nix
    ../../modules/xdg-portal.nix
    ../../modules/security.nix
    ../../modules/autologin.nix
    ../../modules/bluetooth.nix
    ../../modules/frimware-amd.nix
    ../../modules/printing.nix
    ../../modules/mount/music.nix
    ../../modules/mount/share.nix
    ../../modules/grub/os-entry.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "t1";
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

  boot.loader.grub.osEntry = {
    enable = true;
    title = "Bazzite OS";
    class = "fedora";
    uuid = "AD8A-123F";
    path = "/EFI/fedora/grubx64.efi";
  };

  programs.zsh.enable = true;
  system.stateVersion = "25.05";
}
