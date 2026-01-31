{
  pkgs,
  config,
  userName,
  ...
}:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    libva-utils
  ];

  users.users.${userName}.extraGroups = [
    "video"
    "render"
  ];
}
