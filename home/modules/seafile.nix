{ pkgs, ... }:

{
  home.packages = [
    pkgs.seafile-client
  ];

  systemd.user.services.seafile = {
    Unit = {
      Description = "Seafile desktop client";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.seafile-client}/bin/seafile-applet";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
