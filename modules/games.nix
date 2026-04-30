{ pkgs, userName, ... }:

{
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };

  security.pam.loginLimits = [
    {
      domain = userName;
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
      general = {
        desiredgov = "performance";
        inhibit_screensaver = 1;
      };
    };
  };
}
