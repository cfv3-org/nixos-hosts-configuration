{ config, lib, ... }:

let
  sourceDir = ./../../media/wallpappers;
  wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
  wallpapers =
    builtins.sort (a: b: a < b) (
      builtins.filter (
        file:
        (builtins.readDir sourceDir).${file} == "regular"
        && lib.hasSuffix ".jpg" file
      ) (builtins.attrNames (builtins.readDir sourceDir))
    );
  slideDuration = 900;
  transitionDuration = 2;

  wallpaperPath = file: "${wallpaperDir}/${file}";
  wallpaperFiles = builtins.listToAttrs (
    map (file: {
      name = "Pictures/Wallpapers/${file}";
      value.source = sourceDir + "/${file}";
    }) wallpapers
  );
  nextWallpapers = lib.zipListsWith (current: next: {
    inherit current next;
  }) wallpapers ((lib.drop 1 wallpapers) ++ [ (lib.head wallpapers) ]);

  transitionXml = pair: ''
    <static>
      <duration>${toString slideDuration}</duration>
      <file>${wallpaperPath pair.current}</file>
    </static>
    <transition>
      <duration>${toString transitionDuration}</duration>
      <from>${wallpaperPath pair.current}</from>
      <to>${wallpaperPath pair.next}</to>
    </transition>
  '';
in
{
  home.file = wallpaperFiles // {
    "Pictures/Wallpapers/slideshow.xml".text = ''
      <background>
        <starttime>
          <year>2026</year>
          <month>1</month>
          <day>1</day>
          <hour>0</hour>
          <minute>0</minute>
          <second>0</second>
        </starttime>
      ${lib.concatMapStringsSep "" transitionXml nextWallpapers}
      </background>
    '';
  };

  dconf.settings."org/gnome/desktop/background" = {
    picture-uri = "file://${wallpaperDir}/slideshow.xml";
    picture-uri-dark = "file://${wallpaperDir}/slideshow.xml";
    picture-options = "zoom";
  };
}
