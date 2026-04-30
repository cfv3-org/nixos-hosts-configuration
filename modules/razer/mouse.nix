{ pkgs, userName, ... }:

let
  applyMouseDefaults = pkgs.writeShellScript "apply-razer-mouse-defaults" ''
    set -eu

    polychromatic_cli="${pkgs.polychromatic}/bin/polychromatic-cli"

    for attempt in $(seq 1 30); do
      if "$polychromatic_cli" --device mouse --dpi 1800; then
        "$polychromatic_cli" --device mouse --zone scroll --option none || true
        "$polychromatic_cli" --device mouse --zone scroll --option brightness --parameter 0 || true
        exit 0
      fi

      sleep 1
    done

    exit 1
  '';
in

{
  hardware.openrazer = {
    enable = true;
    users = [ userName ];
  };

  environment.systemPackages = with pkgs; [
    libinput
    polychromatic
  ];

  systemd.user.services.razer-mouse-defaults = {
    description = "Apply default Razer mouse DPI and lighting";
    after = [ "openrazer-daemon.service" ];
    wants = [ "openrazer-daemon.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = applyMouseDefaults;
      Restart = "on-failure";
      RestartSec = "5s";
    };

    unitConfig = {
      StartLimitBurst = 12;
      StartLimitIntervalSec = 120;
    };
  };
}
