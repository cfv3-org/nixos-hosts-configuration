{ pkgs, ... }:

{
  home.packages = [
    pkgs.telegram-desktop
    pkgs.signal-desktop
    pkgs.slack
    pkgs.zoom-us
    pkgs.zapzap
  ];
}
