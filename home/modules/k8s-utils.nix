{ pkgs, ... }:

{
  home.packages = [
    pkgs.helm
    pkgs.kubectl
    pkgs.helmfile
    pkgs.werf
  ];
}
