{ pkgs, ... }:

{
  home.packages = [
    pkgs.mailspring
  ];

  systemd.user.services.mailspring = {
    Unit = {
      Description = "Mailspring Email Client";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.mailspring}/bin/mailspring --background";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
