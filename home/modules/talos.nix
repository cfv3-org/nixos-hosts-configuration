{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    pkgsUnstable.talosctl
  ];
}
