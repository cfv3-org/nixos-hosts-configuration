{ pkgs, ... }:
{
  users = {
    mutableUsers = false;

    users = {
      vasary = {
        isNormalUser = true;
        description = "Vasary";
        extraGroups = [
          "wheel"
          "docker"
          "networkmanager"
          "gamemode"
        ];
        hashedPassword = "$6$YzrOfHuh9fwTdxM9$IoZLSsDmUL4K82gztFpAKernb5alyb3665f/TSFTZ.YodczYYYfskc//WvmZjHka3HU852hNcmdNYQ/GmNHGz/";
        shell = pkgs.zsh;
        uid = 1000;
      };
    };
  };
}
