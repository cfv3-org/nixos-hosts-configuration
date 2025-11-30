{ pkgs, ... }:

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
    flameshot
    eza
    pavucontrol
    easyeffects
    podman-compose
    distrobox
    ventoy-full
    usbutils
    bottles
  ];

  home.file.".config/easyeffects/input/meetings.json".source =
    ./presets/easyeffects/voice_noise_reduction.json;

  services.easyeffects.enable = true;
}
