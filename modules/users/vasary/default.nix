{ pkgs, ... }:

{
  imports = [ ../common.nix ];

  users.users.vasary = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "gamemode"
      "video"
    ];
    hashedPassword = "$6$YzrOfHuh9fwTdxM9$IoZLSsDmUL4K82gztFpAKernb5alyb3665f/TSFTZ.YodczYYYfskc//WvmZjHka3HU852hNcmdNYQ/GmNHGz/";
  };

  users.defaultUserShell = pkgs.zsh;
}
