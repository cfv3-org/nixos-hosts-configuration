{ pkgs, ... }:

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
  home.packages = with pkgs; [
    libinput
    polychromatic
  ];

  systemd.user.services.razer-mouse-defaults = {
    Unit = {
      Description = "Apply Razer mouse DPI and lighting";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = applyMouseDefaults;
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
