{ pkgsUnstable, ... }:

let
  startBitwarden = pkgsUnstable.writeShellScript "start-bitwarden-after-keyring" ''
    set -eu

    keyring_probe="${pkgsUnstable.libsecret}/bin/secret-tool"
    bitwarden="${pkgsUnstable.bitwarden-desktop}/bin/bitwarden"

    if ! printf ready | ${pkgsUnstable.coreutils}/bin/timeout 120s "$keyring_probe" store \
      --label="Bitwarden keyring readiness probe" \
      application bitwarden-keyring-probe; then
      exit 75
    fi

    exec "$bitwarden"
  '';
in
{
  home.packages = with pkgsUnstable; [
    bitwarden-desktop
    libsecret
  ];

  systemd.user.services.bitwarden = {
    Unit = {
      Description = "Bitwarden";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      StartLimitBurst = 10;
      StartLimitIntervalSec = "30min";
    };

    Service = {
      ExecStart = startBitwarden;
      Restart = "on-failure";
      RestartSec = "2min";
      TimeoutStartSec = "150s";
    };
  };

  systemd.user.timers.bitwarden = {
    Unit = {
      Description = "Start Bitwarden after login (delayed)";
    };

    Timer = {
      OnStartupSec = "3min";
      Unit = "bitwarden.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
