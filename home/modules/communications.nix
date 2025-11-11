{ pkgs, pkgsUnstable, ... }:

{
  home.packages = [
    pkgs.telegram-desktop
    pkgs.signal-desktop
    pkgs.slack
    pkgsUnstable.zoom-us
    pkgs.zapzap
  ];
}
