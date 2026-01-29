{ pkgs, lib, ... }:
let
  elegantTheme = pkgs.callPackage ./grub/theme/elegant-theme/default.nix { };
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ "xpad" ];

    loader = {
      systemd-boot.enable = false;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 15;
        gfxmodeEfi = "2056x1440";
        gfxpayloadEfi = "keep";

        theme = "${elegantTheme}/grub/themes/Elegant-forest-blur-left-dark";
      };

      efi.canTouchEfiVariables = true;
    };

    loader.timeout = 5;
  };

  environment.systemPackages = with pkgs; [
    os-prober
    elegantTheme
  ];
}
