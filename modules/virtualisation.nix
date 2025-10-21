{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    rootless.enable = true;
  };
}
