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
      rocm-opencl-runtime
    ];
  };

  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.rocm.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
