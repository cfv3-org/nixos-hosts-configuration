{ pkgs, config, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      vaapiVdpau
      libvdpau
      amdvlk
      rocmPackages.clr.icd
      rocmPackages.rocblas
      rocmPackages.rocm-smi
      rocmPackages.rocminfo
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];

  users.users.vasary.extraGroups = [
    "video"
    "render"
  ];

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
