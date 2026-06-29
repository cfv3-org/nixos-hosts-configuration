{ pkgs, ... }:

let
  nodejs = pkgs.nodejs;
in
{
  home.packages = with pkgs; [
    nodejs
    python3
    pnpm
    yarn
  ];
}
