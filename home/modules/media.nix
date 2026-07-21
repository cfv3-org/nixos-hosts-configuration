{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lollypop
    mesa-demos
    picard
    vulkan-tools
  ];
}
