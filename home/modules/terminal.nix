{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    pkgsUnstable.blackbox-terminal
  ];
}
