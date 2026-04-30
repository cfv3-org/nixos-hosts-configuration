{ pkgs, pkgsUnstable, ... }:

let
  wineForBattleNet = pkgsUnstable.wineWow64Packages.stagingFull;

  lutrisForBattleNet = pkgsUnstable.lutris.override {
    steamSupport = false;
    extraPkgs =
      pkgs: with pkgs; [
        gamescope
        umu-launcher
      ];
    extraLibraries =
      pkgs: with pkgs; [
        icu
        libsecret
        libxshmfence
        openssl
      ];
  };

  lutrisWithBattleNetTweaks = pkgsUnstable.symlinkJoin {
    name = "lutris-battlenet";
    paths = [ lutrisForBattleNet ];
    buildInputs = [ pkgsUnstable.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/lutris \
        --set WINE_SIMULATE_WRITECOPY 1 \
        --set PROTON_USE_NTSYNC 0 \
        --set WINEESYNC 1 \
        --set WINEFSYNC 1
    '';
  };
in
{
  home.sessionVariables = {
    PROTON_USE_NTSYNC = "0";
    WINE_SIMULATE_WRITECOPY = "1";
    WINEESYNC = "1";
    WINEFSYNC = "1";
  };

  home.packages = with pkgsUnstable; [
    cabextract
    dxvk
    gamemode
    gamemode.lib
    gamescope
    lutrisWithBattleNetTweaks
    mangohud
    protonup-qt
    umu-launcher
    vkd3d-proton
    wineForBattleNet
    winetricks
  ];
}
