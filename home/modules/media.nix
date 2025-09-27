{ pkgs, ... }:

{
  home.packages = [
    pkgs.lollypop
    pkgs.mesa-demos
    pkgs.vulkan-tools
  ];
}
