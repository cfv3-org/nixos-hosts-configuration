{ pkgsUnstable, ... }:

{
  home.packages = [
    pkgsUnstable.mailspring
  ];

  systemd.user.services.mailspring = {
    Unit = {
      Description = "Mailspring Email Client";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgsUnstable.mailspring}/bin/mailspring --background";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
