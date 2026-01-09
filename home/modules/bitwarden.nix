{ pkgsUnstable, ... }:

{
  home.packages = with pkgsUnstable; [
    bitwarden-desktop
  ];

  systemd.user.services.bitwarden = {
    Unit = {
      Description = "Bitwarden";
    };

    Service = {
      ExecStart = "${pkgsUnstable.bitwarden-desktop}/bin/bitwarden";
      Restart = "on-failure";
    };
  };

  systemd.user.timers.bitwarden = {
    Unit = {
      Description = "Start Bitwarden after login (delayed)";
    };

    Timer = {
      OnStartupSec = "30s";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
