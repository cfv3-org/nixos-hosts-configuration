{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "jb-cleanup";
  version = "1.0";

  src = ./bin/cleanup;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/jb-cleanup
    chmod +x $out/bin/jb-cleanup
  '';
}
