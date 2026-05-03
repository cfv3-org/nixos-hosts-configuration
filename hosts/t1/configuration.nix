{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:

{
  imports = [
    ../../modules/boot.nix
    ../../modules/nix.nix
    ../../modules/virtualisation.nix
    ../../modules/i18n.nix
    ../../modules/no-sleep.nix
    ../../modules/timezone.nix
    ../../modules/maintenance/cleanup.nix
    ../../modules/amd-gpu.nix
    ../../modules/secrets.nix
    ../../modules/online-accounts.nix
    ../../modules/llm.nix
    ../../modules/openclaw/openclaw.nix
    ../../modules/llamacpp/llamacpp.nix
    ../../modules/trusted.nix
    ../../modules/pipewire.nix
    ../../modules/webcam.nix
    ../../modules/xdg-portal.nix
    ../../modules/security.nix
    ../../modules/autologin.nix
    ../../modules/bluetooth.nix
    ../../modules/firmware-amd.nix
    ../../modules/printing.nix
    ../../modules/printers/phaser-3020.nix
    ../../modules/no-docs.nix
    ../../modules/kde-connect.nix
    ../../modules/games.nix
    ../../modules/mount/music.nix
    ../../modules/mount/share.nix
    ../../modules/grub/os-entry.nix
    ../../modules/razer/mouse.nix
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

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  boot.loader.grub.default = "Bazzite OS";
  boot.loader.grub.osEntry = {
    enable = true;
    title = "Bazzite OS";
    class = "fedora";
    uuid = "AD8A-123F";
    path = "/EFI/fedora/grubx64.efi";
  };

  programs.zsh.enable = true;

  programs.winbox = {
    enable = true;
    openFirewall = true;
    package = pkgsUnstable.winbox4;
  };

  environment.variables.QT_QPA_PLATFORM = "wayland;xcb";

  system.stateVersion = "25.05";
}
