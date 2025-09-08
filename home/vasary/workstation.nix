{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./presets/gnome-dconf.nix
  ];

  home = {
    username = "vasary";
    homeDirectory = "/home/vasary";
    stateVersion = "25.05";
    packages = with pkgs; [
      curl
      jq
      yq
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

      gnome-extension-manager
      gnomeExtensions.burn-my-windows
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.advanced-weather-companion
      gnomeExtensions.appindicator
      gnomeExtensions.net-speed-simplified
      gnomeExtensions.bluetooth-battery-meter

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

      flameshot
      eza

      vim
      wget
      git
      gnupg
      gnumake
      dig
      font-manager
      pavucontrol
      easyeffects
      alacritty
      podman-compose
      distrobox
      iw

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

  fonts.fontconfig.enable = true;
  home.file.".config/easyeffects/input/meetings.json".source = ./presets/easyeffects/voice_noise_reduction.json;

  programs = {
    chromium = {
      enable = true;
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
        ll = "eza --icons=always -l";
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
