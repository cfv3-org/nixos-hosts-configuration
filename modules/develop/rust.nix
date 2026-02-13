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
  environment.systemPackages = with pkgs; [
    rustToolchain
    pkg-config
    openssl
    clang
  ];
}
