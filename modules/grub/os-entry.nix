{ lib, config, ... }:

with lib;

let
  cfg = config.boot.loader.grub.osEntry;
in
{
  options.boot.loader.grub.osEntry = {
    enable = mkEnableOption "Enable custom OS entry in GRUB";

    title = mkOption {
      type = types.str;
      description = "Display name for the GRUB entry.";
    };

    class = mkOption {
      type = types.str;
      description = "CSS class (icon theme class) for GRUB entry.";
    };

    uuid = mkOption {
      type = types.str;
      description = "UUID of the EFI partition for OS.";
    };

    path = mkOption {
      type = types.str;
      description = "Path to the OS EFI bootloader.";
    };
  };

  config = mkIf cfg.enable {
    boot.loader.grub.extraEntries = ''
      menuentry "${cfg.title}" --class ${cfg.class} {
        insmod chain
        search --no-floppy --fs-uuid --set=root ${cfg.uuid}
        chainloader ${cfg.path}
      }
    '';
  };
}
