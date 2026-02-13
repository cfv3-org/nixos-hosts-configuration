{ pkgs, ... }:

{
  services = {
    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=10.10.0.2
        FallbackDNS=
        DNSSEC=no
      '';
    };
  };
}
