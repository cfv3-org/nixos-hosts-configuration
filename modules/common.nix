{
  config,
  pkgs,
  lib,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  time = {
    timeZone = "Europe/Berlin";
  };

  environment = {
    systemPackages = with pkgs; [
      gnupg
      gnumake
      bashInteractive
      zsh
    ];
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "virtio_pci"
        "virtio_blk"
        "virtio_net"
      ];
    };
  };

  services = {
    qemuGuest = {
      enable = lib.mkDefault true;
    };
    resolved = {
      enable = true;
    };
  };

  networking = {
    useNetworkd = true;
  };
}
