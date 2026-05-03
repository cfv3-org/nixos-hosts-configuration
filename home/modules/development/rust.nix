{ pkgs, ... }:

let
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [
      "rust-src"
      "rustfmt"
      "clippy"
      "rust-analyzer"
    ];
  };
in
{
  home.packages = with pkgs; [
    openssl
    pkg-config
    rustToolchain
  ];
}
