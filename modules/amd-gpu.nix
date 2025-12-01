{ pkgs, config, userName, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau

      rocmPackages.clr.icd
      rocmPackages.rocblas
      rocmPackages.hipblas
      rocmPackages.hiprt
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];

  users.users.${userName}.extraGroups = [
    "video"
    "render"
  ];

  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    HSA_OVERRIDE_GFX_VERSION = "12.0.0";
    ROCR_VISIBLE_DEVICES = "0";
  };
}
