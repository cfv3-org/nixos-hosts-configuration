{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_17;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
