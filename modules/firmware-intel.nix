{ pkgs, config, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
}
