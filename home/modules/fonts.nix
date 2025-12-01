{ pkgs, ... }:

{
  home.packages = [
    pkgs.font-manager

    pkgs.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.ubuntu
    pkgs.nerd-fonts.fantasque-sans-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.inter
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji
  ];

  fonts.fontconfig.enable = true;
}
