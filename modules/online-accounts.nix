{ pkgs, ... }:

{
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.geary.enable = true;

  environment.systemPackages = [
    pkgs.gnome-calendar
  ];
}
