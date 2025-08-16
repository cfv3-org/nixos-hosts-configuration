{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/common.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/virtualisation.nix
    ../../modules/storage.nix
    ../../modules/vscode-server.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "workbench";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = "25.05";
}
