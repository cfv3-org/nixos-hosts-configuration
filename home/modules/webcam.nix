{ pkgs, ... }:

let
  webcamQuality = pkgs.writeShellScriptBin "webcam-quality" ''
    set -eu

    device="''${1:-/dev/video0}"

    ${pkgs.v4l-utils}/bin/v4l2-ctl --device="$device" \
      --set-fmt-video=width=1920,height=1080,pixelformat=MJPG \
      --set-parm=30 \
      --set-ctrl=power_line_frequency=1,exposure_dynamic_framerate=0
  '';
in
{
  home.packages = with pkgs; [
    webcamQuality
    ffmpeg-full
    guvcview
    libcamera
    snapshot
    v4l-utils

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];
}
