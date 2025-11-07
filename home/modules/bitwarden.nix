{ pkgs, ... }:

{
  home.packages = [
    pkgs.bitwarden-desktop
  ];

  systemd.user.services = {
    #      telegram = {
    #        Unit = {
    #          Description = "Telegram Desktop autostart";
    #          After = [ "graphical-session.target" ];
    #        };
    #        Service = {
    #          ExecStart = "${pkgs.telegram-desktop}/bin/telegram-desktop";
    #          Restart = "on-failure";
    #        };
    #        Install = {
    #          WantedBy = [ "graphical-session.target" ];
    #        };
    #      };
    #
    #      zapzap = {
    #        Unit = {
    #          Description = "ZapZap autostart";
    #          After = [ "graphical-session.target" ];
    #        };
    #        Service = {
    #          ExecStart = "${pkgs.zapzap}/bin/zapzap";
    #          Restart = "on-failure";
    #        };
    #        Install = {
    #          WantedBy = [ "graphical-session.target" ];
    #        };
    #      };

    bitwarden = {
      Unit = {
        Description = "Bitwarden autostart";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
