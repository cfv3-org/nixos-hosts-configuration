{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    curl
    jq
    yq
    htop
    unzip
    fastfetch
    pciutils
    iw
    vim
    wget
    gnupg
    gnumake
    dig
    eza
    pavucontrol
    podman-compose
    distrobox
    ventoy-full
    usbutils
    bottles
    pkgsUnstable.yandex-cloud
    pkgsUnstable.audacity
  ];
}
