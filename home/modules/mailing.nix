{ pkgs, ... }:

{
  home.packages = with pkgs; [
    geary
    gnome-calendar
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/mailto" = [ "org.gnome.Geary.desktop" ];
    "message/rfc822" = [ "org.gnome.Geary.desktop" ];
  };
}
