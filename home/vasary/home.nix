{
  config,
  pkgs,
  lib,
  ...
}:

{
  dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 4;
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "ru"
        ])
      ];
      xkb-options = [ "grp:ctrl_shift_toggle" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-date = true;
      enable-hot-corners = false;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      accel-profile = "flat";
      speed = 0.75;
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
    "org/gnome/shell/extensions/quick-settings-tweaks" = {
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "quick-settings-tweaks@qwreey"
        "burn-my-windows@schneegans.github.com"
        "clipboard-indicator@tudmotu.com"
        "advanced-weather@sanjai.com"
      ];
    };
  };

  home = {
    username = "vasary";
    homeDirectory = "/home/vasary";
    stateVersion = "25.05";
    packages = with pkgs; [
      git
      curl
      wget
      jq
      yq
      docker-compose
      helm
      kubectl
      helmfile
      talosctl
      werf
      direnv
      unzip
      nixfmt-rfc-style
      jetbrains.idea-community-bin
      #      jetbrains.datagrip
      #      jetbrains.phpstorm
      jetbrains.jdk
      telegram-desktop

      gnomeExtensions.burn-my-windows
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.advanced-weather-companion

    ];
  };

  programs = {
    gnome-shell = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Viktor Gievoi";
      userEmail = "gievoi.v@gmail.com";
      extraConfig = {
        pull.rebase = true;
        merge.ff = "only";
        init.defaultBranch = "main";
        push.default = "current";
        color.ui = "auto";
        core.autocrlf = "input";
        fetch.prune = true;
        rebase.autoStash = true;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
      };
      autocd = true;

      shellAliases = {
        k = "kubectl";
      };

      history = {
        append = true;
        extended = true;
        ignoreAllDups = true;
      };

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "sudo"
          "colored-man-pages"
        ];
      };
    };
  };
}
