{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/virtualisation.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = ''
      options mt7921e disable_aspm=1
    '';
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

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
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      xdgOpenUsePortal = true;
    };
    mime.defaultApplications = {
      "x-scheme-handler/terminal" = "alacritty.desktop";
    };
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

  time.timeZone = "Europe/Berlin";

  console = {
    useXkbConfig = true;
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    printing = {
      enable = true;
    };

    pulseaudio = {
      enable = false;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    displayManager.autoLogin = {
      enable = true;
      user = "vasary";
    };

    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=10.10.0.2 8.8.8.8
        Domains=~cfv3.org
      '';
    };
  };

  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  programs = {
    steam = {
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    chromium = {
      enable = true;
      extraOpts = {
        "HomepageLocation" = "http://start.cfv3.org";
        "RestoreOnStartup" = 5;
      };
    };
    ssh.startAgent = false;
    gamemode.enable = true;
    firefox.enable = false;
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [ ];

  security = {
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  fileSystems."/mnt/warehouse" = {
    device = "/dev/disk/by-uuid/eb1a4d30-9372-4645-b5c6-67004a6df912";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "x-systemd.device-timeout=10s"
      "x-systemd.automount"
      "x-systemd.idle-timeout=1min"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
