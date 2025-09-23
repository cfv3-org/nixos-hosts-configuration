{
  pkgs,
  lib,
  config,
  ...
}:

{
  home.packages = [
    pkgs.gnome-extension-manager
    pkgs.gnomeExtensions.burn-my-windows
    pkgs.gnomeExtensions.clipboard-indicator
    pkgs.gnomeExtensions.quick-settings-tweaker
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.net-speed-simplified
    pkgs.gnomeExtensions.bluetooth-battery-meter
    pkgs.gnomeExtensions.vitals
  ];

  programs = {
    gnome-shell.enable = true;
  };

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
      xkb-options = [ "grp:alt_space_toggle" ];
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
      mode = 2;
      textalign = 2;
      wpos = 0;
      wposext = 0;
      limitunit = 0;
      refreshtime = 1;
      minwidth = 8.0;

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
        "appindicatorsupport@rgcjonas.gmail.com"
        "netspeedsimplified@prateekmedia.extension"
        "Vitals@CoreCoding.com"
      ];
    };
    "org/gnome/shell/keybindings" = {
      screenshot = [ ];
      show-screenshot-ui = [ ];
      screenshot-window = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "Print";
      command = "script --command 'QT_QPA_PLATFORM=wayland flameshot gui --clipboard' /dev/null";
      name = "Flameshot GUI";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift>Print";
      command = "script --command 'QT_QPA_PLATFORM=wayland flameshot full --clipboard -p $HOME/Pictures/Screenshots' /dev/null";
      name = "Flameshot Full Screen";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Alt>Print";
      command = "script --command 'QT_QPA_PLATFORM=wayland flameshot screen --clipboard -p $HOME/Pictures/Screenshots' /dev/null";
      name = "Flameshot Current Screen";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/Pictures/Wallpapers/wallpaper.jpg";
      picture-options = "zoom";
    };
    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = true;
      hide-zeros = false;
      icon-style = 1;
      include-static-gpu-info = true;
      memory-measurement = 1;
      menu-centered = true;
      show-battery = false;
      show-fan = false;
      show-gpu = true;
      show-memory = true;
      show-network = false;
      show-processor = true;
      show-storage = true;
      show-temperature = true;
      show-voltage = false;
      update-time = 2;
      use-higher-precision = false;
      hide-icons = false;
    };
    "org/gnome/desktop/applications/media" = {
      player = "org.gnome.Lollypop.desktop";
    };
    "org/gnome/desktop/applications/audio" = {
      exec = "lollypop %U";
    };
    "org/gnome/shell/world-clocks" = {
      locations = [
        (lib.hm.gvariant.mkVariant (
          lib.hm.gvariant.mkTuple [
            (lib.hm.gvariant.mkUint32 2)
            (lib.hm.gvariant.mkVariant (
              lib.hm.gvariant.mkTuple [
                "Moscow"
                "UUWW"
                true
                [
                  (lib.hm.gvariant.mkTuple [
                    0.97127572873484425
                    0.65042604039431762
                  ])
                ]
                [
                  (lib.hm.gvariant.mkTuple [
                    0.97305983920281813
                    0.65651530216830811
                  ])
                ]
              ]
            ))
          ]
        ))
        (lib.hm.gvariant.mkVariant (
          lib.hm.gvariant.mkTuple [
            (lib.hm.gvariant.mkUint32 2)
            (lib.hm.gvariant.mkVariant (
              lib.hm.gvariant.mkTuple [
                "Bishkek"
                "UCFM"
                true
                [
                  (lib.hm.gvariant.mkTuple [
                    0.74827598759191005
                    1.3020204740030903
                  ])
                ]
                [
                  (lib.hm.gvariant.mkTuple [
                    0.74827598759191005
                    1.3020204740030903
                  ])
                ]
              ]
            ))
          ]
        ))
      ];
    };
    "org/gnome/clocks" = {
      world-clocks = [
        ([
          (lib.hm.gvariant.mkDictionaryEntry [
            "location"
            (lib.hm.gvariant.mkVariant (
              lib.hm.gvariant.mkTuple [
                (lib.hm.gvariant.mkUint32 2)
                (lib.hm.gvariant.mkVariant (
                  lib.hm.gvariant.mkTuple [
                    "Moscow"
                    "UUWW"
                    true
                    [
                      (lib.hm.gvariant.mkTuple [
                        0.97127572873484425
                        0.65042604039431762
                      ])
                    ]
                    [
                      (lib.hm.gvariant.mkTuple [
                        0.97305983920281813
                        0.65651530216830811
                      ])
                    ]
                  ]
                ))
              ]
            ))
          ])
        ])
        ([
          (lib.hm.gvariant.mkDictionaryEntry [
            "location"
            (lib.hm.gvariant.mkVariant (
              lib.hm.gvariant.mkTuple [
                (lib.hm.gvariant.mkUint32 2)
                (lib.hm.gvariant.mkVariant (
                  lib.hm.gvariant.mkTuple [
                    "Bishkek"
                    "UCFM"
                    true
                    [
                      (lib.hm.gvariant.mkTuple [
                        0.74827598759191005
                        1.3020204740030903
                      ])
                    ]
                    [
                      (lib.hm.gvariant.mkTuple [
                        0.74827598759191005
                        1.3020204740030903
                      ])
                    ]
                  ]
                ))
              ]
            ))
          ])
        ])
      ];
    };
    "org/gnome/desktop/session" = {
      idle-delay = 0;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-battery-timeout = 0;
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
  };
}
