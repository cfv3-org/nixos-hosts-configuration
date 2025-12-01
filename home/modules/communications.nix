{ pkgs, pkgsUnstable, ... }:

{
  home.packages = [
    pkgsUnstable.telegram-desktop
    pkgsUnstable.signal-desktop
    pkgsUnstable.zoom-us
    pkgsUnstable.zapzap
    pkgs.slack
  ];

  systemd.user.services = {
    telegram = {
      Unit = {
        Description = "Telegram Desktop autostart";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgsUnstable.telegram-desktop}/bin/Telegram -startintray --enable-wayland-ime";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    zapzap = {
      Unit = {
        Description = "ZapZap autostart";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgsUnstable.zapzap}/bin/zapzap --minimized --ozone-platform=wayland --enable-features=WaylandWindowDecorations";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
