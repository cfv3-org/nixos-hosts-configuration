{
  pkgs,
  pkgsUnstable,
  userName,
  ...
}:
{
  users.users.${userName}.extraGroups = [ "podman" ];
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    package = pkgsUnstable.podman;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
}
