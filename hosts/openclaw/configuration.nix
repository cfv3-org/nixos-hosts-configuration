{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nix.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "claw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.openssh.enable = true;

  services.openssh.settings = {
    PermitRootLogin = "yes";
    PasswordAuthentication = true;
  };

  users = {
      mutableUsers = false;

      users."openclaw" = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPassword = "";
        uid = 1000;
      };
    };

  system.stateVersion = "25.11";
}

