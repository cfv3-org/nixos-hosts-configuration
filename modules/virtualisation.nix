{ pkgs, userName, ... }:
{
  users.users.${userName}.extraGroups = [ "podman" ];
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}
