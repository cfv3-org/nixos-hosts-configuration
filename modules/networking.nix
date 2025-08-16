{ lib, ... }:
{
  systemd = {
    network = {
      enable = true;
      networks = {
        "10-ens3" = {
          matchConfig = {
            Name = "ens3";
          };
          linkConfig = {
            RequiredForOnline = "no";
          };
          networkConfig = {
            DHCP = "no";
            LinkLocalAddressing = "no";
            IPv6AcceptRA = false;
          };
          addresses = [
            { Address = "192.168.50.2/24"; }
          ];
          routes = [ ];
          dns = [ ];
        };

        "20-ens4" = {
          matchConfig = {
            Name = "ens4";
          };
          networkConfig = {
            DHCP = "yes";
          };
          dhcpV4Config = {
            RouteMetric = 100;
            UseRoutes = true;
            UseDNS = true;
          };
        };
      };
    };
  };
}
