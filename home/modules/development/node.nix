{ pkgs, ... }:

let
  nodejs = pkgs.nodejs_20;
in
{
  home.packages = with pkgs; [
    nodejs
    pnpm
    yarn
  ];
}
