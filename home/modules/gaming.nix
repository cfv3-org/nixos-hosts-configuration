{ pkgs, ... }:

{
  home.packages = [
    pkgs.protonup-qt
    pkgs.lutris
    pkgs.gamemode
    pkgs.gamemode.lib
    pkgs.mangohud
    pkgs.libstrangle
  ];
}
