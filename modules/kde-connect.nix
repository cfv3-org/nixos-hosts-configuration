{ pkgs, config, ... }:

{
  programs.kdeconnect.enable = true;

  services.gnome.gnome-browser-connector.enable = true;
}
