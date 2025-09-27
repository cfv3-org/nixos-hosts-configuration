{ pkgs, ... }:

{
  services.printing = {
    drivers = [ pkgs.nur.repos.crtified.phaser_3020 ];
  };

  hardware.printers = {
    ensurePrinters = [
      #      {
      #        name = "Xerox3020";
      #        deviceUri = "socket://192.168.178.26";
      #      }
    ];
    #    ensureDefaultPrinter = "Xerox3020";
  };
}
