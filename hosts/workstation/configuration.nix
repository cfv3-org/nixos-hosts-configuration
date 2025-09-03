{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/virtualisation.nix
    ../../modules/users.nix
    ./hardware-configuration.nix
  ];

  boot = {
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
  };

  networking = {
    hostName = "workstation";
    networkmanager = {
      enable = true;
      unmanaged = [ "wlp91s0" ];
    };
    wireless = {
      enable = true;
      networks = {
        "Vasary" = {
          psk = "36299104178767417451";
        };
      };
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

programs.dconf.enable = true;

dconf.settings = {
  "org/gnome/desktop/input-sources" = {
    sources = [
      (lib.gvariant.mkTuple [ "xkb" "us" ])
      (lib.gvariant.mkTuple [ "xkb" "ru" ])
    ];
    xkb-options = [ "grp:win_space_toggle" ];
  };
};

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
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    displayManager.autoLogin = {
      enable = true;
      user = "vasary";
    };
  };

  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  programs = {
    firefox = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
    gamemode = {
      enable = true;
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
      remotePlay = {
        openFirewall = true;
      };
      dedicatedServer = {
        openFirewall = true;
      };
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    chromium
    vscode
    git
    gnupg
    gnumake
    bashInteractive
    zsh
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
    font-manager
  ];

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
  ];

  security = {
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  system.stateVersion = "25.05";
}
