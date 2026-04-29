{ pkgs, ... }:

let
  nodejs = pkgs.nodejs_20;
in
{
  environment.systemPackages = with pkgs; [
    nodejs
    yarn
    pnpm
  ];
}
