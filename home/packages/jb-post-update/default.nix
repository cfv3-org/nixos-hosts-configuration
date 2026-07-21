{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "jb-post-update";
  version = "1.0";

  src = ./bin/post-update;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/jb-post-update
    chmod +x $out/bin/jb-post-update
  '';

  meta.mainProgram = "jb-post-update";
}
