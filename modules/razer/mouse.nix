{ pkgs, userName, ... }:

{
  hardware.openrazer = {
    enable = true;
    users = [ userName ];
  };

  environment.systemPackages = with pkgs; [
    polychromatic
  ];
}
