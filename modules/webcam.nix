{ pkgs, ... }:

{
  boot.kernelModules = [ "uvcvideo" ];

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="video4linux", ENV{ID_VENDOR_ID}=="1532", ENV{ID_MODEL_ID}=="0e06", ENV{ID_V4L_CAPABILITIES}=="*:capture:*", RUN+="${pkgs.v4l-utils}/bin/v4l2-ctl --device=$devnode --set-ctrl=power_line_frequency=1,exposure_dynamic_framerate=0"
  '';
}
