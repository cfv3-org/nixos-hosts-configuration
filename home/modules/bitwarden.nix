{ pkgsUnstable, ... }:

{
  home.packages = with pkgsUnstable; [
    bitwarden-desktop
  ];

  systemd.user.services = {
    bitwarden = {
      Unit = {
        Description = "Bitwarden autostart";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgsUnstable.bitwarden-desktop}/bin/bitwarden";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
