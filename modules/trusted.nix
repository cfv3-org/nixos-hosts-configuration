{ pkgs, ... }:
{
  security.pam.services = {
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  services = {
    dbus.packages = with pkgs; [ gcr ];
    gnome.gnome-keyring.enable = true;
  };
}
