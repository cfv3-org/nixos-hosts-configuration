{ pkgs, ... }:

{
  services = {
    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=10.10.0.2 192.168.178.1 8.8.8.8
        Domains=~cfv3.org
      '';
    };
  };
}
