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
      jetbrains.goland

      telegram-desktop
      signal-desktop
      slack
      zoom-us
      zapzap

      gnome-extension-manager
      gnomeExtensions.burn-my-windows
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.appindicator
      gnomeExtensions.net-speed-simplified
      gnomeExtensions.bluetooth-battery-meter
      gnomeExtensions.vitals

      protonup-qt
      lutris
      gamemode
      gamemode.lib
      mangohud

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
      podman-compose
      distrobox
      iw

      jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.jetbrains-mono
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      fastfetch

      kitty

      lollypop
    ];
  };

  fonts.fontconfig.enable = true;

  home.file.".config/easyeffects/input/meetings.json".source =
    ./presets/easyeffects/voice_noise_reduction.json;
  home.file.".config/kitty/kitty.conf".source = ./presets/kitty/kitty.conf;
  home.file."Pictures/Wallpapers/wallpaper.jpg".source = ./../../media/wallpappers/wallpaper.jpg;
  home.file.".config/git/ignore".text = ''
    .idea/
    .vscode/
    .direnv/
  '';

  services.easyeffects.enable = true;

  programs = {
    gnome-shell.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-shaderfilter
        obs-composite-blur
      ];
    };

    chromium = {
      enable = true;
      extensions = [
        # Bitwarden
        "nngceckbapebfimnlniiiahkandclblb"
      ];
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
        core.excludesFile = "~/.config/git/ignore";
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
        docker-compose = "podman-compose";
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
