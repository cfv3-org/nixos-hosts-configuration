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
    "org/gnome/shell/extensions/clipboard-indicator" = {
      cache-size = 50;
      confirm-clear = false;
      disable-down-arrow = true;
      display-mode = 0;
      history-size = 50;
      keep-selected-on-clear = true;
      notify-on-copy = false;
      paste-button = false;
      preview-size = 10;
      topbar-preview-size = 1;
    };
    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      add-unsafe-quick-toggle-enabled = false;
      datemenu-remove-media-control = true;
      disable-remove-shadow = false;
      input-always-show = false;
      input-show-selected = true;
      notifications-enabled = true;
      notifications-hide-when-no-notifications = false;
    };
    "org/gnome/shell/extensions/appindicator" = {
      "icon-brightness" = 0;
      "icon-contrast" = 0;
      "icon-opacity" = 240;
      "icon-saturation" = 0;
      "icon-size" = 20;
      "legacy-tray-enabled" = true;
    };
    "org/gnome/shell/extensions/netspeedsimplified" = {
      chooseiconset = 2;
      fontmode = 1;
      mode = 5;
      textalign = 1;
      wpos = 0;
      wposext = 1;
      limitunit = 0;
      refreshtime = 2;
      minwidth = 2;

      iconstoright = false;
      isvertical = true;
      lockmouseactions = true;
      restartextension = false;
      reverseindicators = true;
      shortenunits = true;
      togglebool = false;
      hideindicator = false;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "quick-settings-tweaks@qwreey"
        "burn-my-windows@schneegans.github.com"
        "clipboard-indicator@tudmotu.com"
        "advanced-weather@sanjai.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "netspeedsimplified@prateekmedia.extension"
      ];
    };
  };

  home = {
    username = "vasary";
    homeDirectory = "/home/vasary";
    stateVersion = "25.05";
    packages = with pkgs; [
      curl
      jq
      yq
      docker-compose
      helm
      kubectl
      helmfile
      talosctl
      werf
      direnv
      nix-direnv
      unzip
      nixfmt-rfc-style

      jetbrains.idea-community-bin
      jetbrains.datagrip
      jetbrains.phpstorm
      jetbrains.jdk

      telegram-desktop
      signal-desktop
      slack
      zoom-us

      gnomeExtensions.burn-my-windows
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.advanced-weather-companion
      gnomeExtensions.appindicator
      gnomeExtensions.net-speed-simplified

      protonup-qt
      lutris
      bottles
      bitwarden-desktop

      thunderbird-bin
      libreoffice
      hunspell
      hunspellDicts.ru_RU
      hunspellDicts.en_US
      hunspellDicts.de_DE
      hyphen
    ];
  };

  programs = {
    chromium = {
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb"
      ];
    };
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

      initContent = ''
        export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
        eval "$(direnv hook zsh)"
      '';

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
