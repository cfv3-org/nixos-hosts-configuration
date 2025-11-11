{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lollypop
    mesa-demos
    vulkan-tools
  ];
}
