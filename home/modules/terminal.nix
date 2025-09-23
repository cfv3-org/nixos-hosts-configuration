{ pkgs, ... }:

{
  home.packages = [
    pkgs.kitty
  ];

  home.file.".config/kitty/kitty.conf".source = ./presets/kitty/kitty.conf;
}
