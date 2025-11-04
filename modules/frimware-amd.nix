{ pkgs, config, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.amd.intel.updateMicrocode = true;
}
