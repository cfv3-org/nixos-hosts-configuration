{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/nix.nix
    ../../modules/virtualisation.nix
    ../../modules/llm.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    ../../modules/no-sleep.nix
    ../../modules/mount-warehouse.nix
    ../../modules/mount-music.nix
    ../../modules/timezone.nix
    ../../modules/games.nix
    ../../modules/cfv3-resolved.nix
    ../../modules/nvidia.nix
    ../../modules/pipewire.nix
    ../../modules/xdg-portal.nix
    ../../modules/security.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    extraModprobeConfig = ''
      options mt7921e disable_aspm=1
    '';

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = with pkgs; [ ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
    enableAllFirmware = true;
  };

  networking = {
    hostName = "workstation";
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
      };
    };
  };

  services = {
    printing.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  programs = {
    zsh.enable = true;
  };

  system.stateVersion = "25.05";
}
