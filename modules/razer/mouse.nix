{ pkgs, userName, ... }:

{
  hardware.openrazer = {
    enable = false;
    users = [ userName ];
  };

  environment.systemPackages = with pkgs; [
    polychromatic
  ];
}
