{ lib, pkgs, ... }:

let
  printerName = "Phaser_3020";
in
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "samsung-unified-linux-driver"
    ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver ];
  };

  hardware.printers = {
    ensureDefaultPrinter = printerName;
    ensurePrinters = [
      {
        name = printerName;
        description = "Xerox Phaser 3020";
        location = "192.168.178.26";
        deviceUri = "socket://192.168.178.26:9100";
        model = "samsung/ML-2160.ppd";
        ppdOptions = {
          PageSize = "A4";
          Resolution = "600dpi";
          MediaType = "Plain";
          InputSlot = "Auto";
          JCLDarkness = "NORMAL";
        };
      }
    ];
  };
}
