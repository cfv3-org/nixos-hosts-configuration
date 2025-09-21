{ pkgs, ... }:

{
  programs = {
    gamemode = {
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

    steam = {
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
