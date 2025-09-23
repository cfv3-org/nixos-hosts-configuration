{ pkgs, ... }:

{
  home.packages = [
    pkgs.curl
    pkgs.jq
    pkgs.yq
    pkgs.htop
    pkgs.unzip
    pkgs.fastfetch
    pkgs.pciutils
    pkgs.iw
    pkgs.vim
    pkgs.wget
    pkgs.gnupg
    pkgs.gnumake
    pkgs.dig
    pkgs.flameshot
    pkgs.eza
    pkgs.pavucontrol
    pkgs.easyeffects
    pkgs.podman-compose
    pkgs.distrobox
  ];

  home.file.".config/easyeffects/input/meetings.json".source =
    ./presets/easyeffects/voice_noise_reduction.json;

  services.easyeffects.enable = true;
}
