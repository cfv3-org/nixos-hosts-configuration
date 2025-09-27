{ pkgs, userName, ... }:
{
  users = {
    mutableUsers = false;

    users.${userName} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "gamemode"
        "video"
      ];
      hashedPassword = "$6$YzrOfHuh9fwTdxM9$IoZLSsDmUL4K82gztFpAKernb5alyb3665f/TSFTZ.YodczYYYfskc//WvmZjHka3HU852hNcmdNYQ/GmNHGz/";
      shell = pkgs.zsh;
      uid = 1000;
    };
  };
}
