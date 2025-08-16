{
  config,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.qemuGuest.enable = lib.mkDefault true;

  networking = {
    hostName = "ci-runner";
    useNetworkd = true;
  };

  systemd = {
    network.enable = true;
    network.networks = {
      "10-ens18" = {
        matchConfig.Name = "ens18";
        networkConfig.DHCP = "yes";
        dhcpV4Config = {
          RouteMetric = 100;
          UseRoutes = true;
          UseDNS = true;
        };
      };
      "20-ens19" = {
        matchConfig.Name = "ens19";
        networkConfig.DHCP = "yes";
        dhcpV4Config = {
          RouteMetric = 200;
          UseRoutes = false;
          UseDNS = false;
        };
      };
    };
  };

  time.timeZone = "Europe/Berlin";

  users = {
    users = {
      github-runner = {
        isNormalUser = true;
        description = "GitHub Actions Runner";
        extraGroups = [ "docker" ];
        packages = with pkgs; [
          git
          werf
          kubectl
        ];
        home = "/home/github-runner";
        createHome = true;
      };

      root = {
        initialPassword = lib.mkForce null;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQE8eLt55jCL1f1DC1nf1gJ8BjaRo5tXycN1CVcHq98URvH32VAkP/FzWTHNlInNeK0pRtnHpAW0R9JuGRYYp9WpQBEGJ9Oh/GNnyV7Ujlf5XnzYsPd599xJwPZ3yxvk8EKHGeX7Ne835roCpv7YnUmFS/Uji+2bj3lW3UApkeAhOlm2Q593hcMhjMvHaHRVOjfAw1E0kFpDnL7UhwYu09TAJbf1grno5tDft1SEbsku78z952aXwEyFAKjlyMaecB5cy/1AusmTNVpxI0ozNW5oXHn6/WLZoNj6ffoUusJX8+667J3Y5mUZ3687rnfm0R8PVmFe/PtR05POmAswMbfNpQfNjsCCUgLleznE19i/xxm/vk8O/JP7gqXuRKe5EYFMnO7LNB3sdCi9/o2izgUPPnqcg8TzVNsbsXrY+JCZSGfV+iYZC/aEXXlAVDc7SqRJ+6U6TtSY1H22JpGILD0v1HPEqDloOJ+q9OJemcG2kgTkbmvglLyR0ozu7AZM/g5jS5djYZFRdlCp7bbNjnVWMZAnCvUsjQXNIM4AP4mSQGXD8ZOAdVw1ZF5tX3ELfQ1rlGM/iV8aFgu1LdYDSYe9Sk+SMTsmzYO7vvGgKJtOdd7nSBpQB4KDvlePS31pGF1zr7YBgojNjmv3v9dBz5QuSnBbIVBpEQSbztIRqR3Q=="
        ];
      };
    };

    groups.github-runner = { };
    mutableUsers = false;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    gnupg
    systemd
    werf
    kubectl
  ];

  virtualisation.docker.enable = true;

  services = {
    resolved.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
      };
    };

    github-runners = {
      lab = {
        enable = true;
        user = "github-runner";
        name = "lab-runner";
        tokenFile = "/etc/github-runner/token_lab";
        url = "https://github.com/cfv3-org";
      };
    };
  };

  i18n = {
    supportedLocales = [
      "ru_RU.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    defaultLocale = "en_US.UTF-8";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.05";
}
