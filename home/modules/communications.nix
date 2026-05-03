{ pkgs, pkgsUnstable, ... }:
let
  zapzap = pkgsUnstable.symlinkJoin {
    name = "zapzap-xwayland";
    paths = [ pkgsUnstable.zapzap ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm -f "$out/bin/zapzap"
      makeWrapper ${pkgsUnstable.zapzap}/bin/zapzap "$out/bin/zapzap" \
        --set QT_QPA_PLATFORM xcb \
        --set QTWEBENGINE_CHROMIUM_FLAGS "--ozone-platform=x11" \
        --set QT_OPENGL desktop
    '';
  };
in

{
  home.packages = [
    pkgsUnstable.telegram-desktop
    pkgsUnstable.signal-desktop
    pkgsUnstable.zoom-us
    zapzap
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
        ExecStart = "${zapzap}/bin/zapzap --minimized";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
