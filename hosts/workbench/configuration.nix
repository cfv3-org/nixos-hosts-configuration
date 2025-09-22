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
    ../../modules/nix.nix
    ../../modules/timezone.nix
    ../../modules/users.nix
    ../../modules/virtualisation.nix
    ../../modules/storage.nix
    ../../modules/vscode-server.nix
    ../../modules/security.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "workbench";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    gnupg
    gnumake
    bashInteractive
    zsh
  ];

  programs.zsh.enable = true;

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_net"
  ];

  services = {
    qemuGuest.enable = true;
    resolved.enable = true;
  };

  networking = {
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-ens3" = {
        matchConfig.Name = "ens3";
        linkConfig.RequiredForOnline = "no";

        networkConfig = {
          DHCP = "no";
          LinkLocalAddressing = "no";
          IPv6AcceptRA = false;
        };
        addresses = [
          { Address = "192.168.50.2/24"; }
        ];
        routes = [ ];
        dns = [ ];
      };

      "20-ens4" = {
        matchConfig.Name = "ens4";
        networkConfig.DHCP = "yes";

        dhcpV4Config = {
          RouteMetric = 100;
          UseRoutes = true;
          UseDNS = true;
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = "25.05";
}
