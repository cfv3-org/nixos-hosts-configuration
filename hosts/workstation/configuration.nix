{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/virtualisation.nix
    ../../modules/ai.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    extraModprobeConfig = ''
      options mt7921e disable_aspm=1
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
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
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      xdgOpenUsePortal = true;
    };
    mime.defaultApplications = {
      "x-scheme-handler/terminal" = "alacritty.desktop";
      "audio/mpeg" = [ "org.gnome.Lollypop.desktop" ];
      "audio/flac" = [ "org.gnome.Lollypop.desktop" ];
      "audio/ogg" = [ "org.gnome.Lollypop.desktop" ];
      "audio/wav" = [ "org.gnome.Lollypop.desktop" ];
      "audio/x-m4a" = [ "org.gnome.Lollypop.desktop" ];
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
    printing.enable = true;
    pulseaudio.enable = false;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
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
        DNS=10.10.0.2 192.168.178.1 8.8.8.8
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
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
        general = {
          desiredgov = "performance";
          inhibit_screensaver = 1;
        };
      };
    };
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
        "PasswordManagerEnabled" = false;
        "HomepageLocation" = "http://start.cfv3.org";
        "RestoreOnStartup" = 5;
      };
    };
    ssh.startAgent = false;
    firefox.enable = false;
    zsh.enable = true;
  };

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
      options = "--delete-older-than 1d";
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

  fileSystems."/home/vasary/Music" = {
    device = "10.10.0.4:/mnt/archive/media/music";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "_netdev"
      "vers=4.1"
      "proto=tcp"
      "hard"
      "nconnect=4"
      "fsc"
      "noatime"
    ];
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
