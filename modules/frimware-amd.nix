{ pkgs, config, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
}
