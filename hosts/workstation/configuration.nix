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
    };

    displayManager.autoLogin = {
      enable = true;
      user = "vasary";
    };

    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=10.10.0.2
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
    };
    steam = {
      extraCompatPackages = [ pkgs.proton-ge-bin ];
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
    ssh = {
      startAgent = false;
    };
    chromium = {
      enable = true;
      extraOpts = {
        "HomepageLocation" = "http://start.cfv3.org";
        "HomepageIsNewTabPage" = false;
        "RestoreOnStartup" = 4;
        "RestoreOnStartupURLs" = [ "http://start.cfv3.org" ];
      };
    };
    firefox = {
      enable = false;
    };
    zsh = {
      enable = true;
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
    dig
    oh-my-zsh
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-autosuggestions
    zsh-completions
    gnome-extension-manager
    mangohud

    font-manager
    podman-compose
    toolbox
    distrobox

    pavucontrol
    easyeffects
  ];

  fonts = {
    fontconfig = {
      enable = true;
    };

    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
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
      options = "--delete-older-than 7d";
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

  system.stateVersion = "25.05";
}
