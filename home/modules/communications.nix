{ pkgs, ... }:

{
  home.packages = [
    pkgs.telegram-desktop
    pkgs.signal-desktop
    pkgs.slack
    pkgs.zoom-us
    pkgs.zapzap
    pkgs.mailspring
  ];

  systemd.user.services.mailspring = {
    Unit = {
      Description = "Mailspring Email Client";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.mailspring}/bin/mailspring";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
