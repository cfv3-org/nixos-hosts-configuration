{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

let
  jetbrainsPackages = with pkgs.jetbrains; [
    idea
    datagrip
    phpstorm
    goland
    webstorm
    rust-rover
  ];

  jetbrainsManifest = pkgs.writeText "jetbrains-products-manifest" (
    lib.concatMapStringsSep "\n" toString jetbrainsPackages
  );

  jetbrainsPostUpdate = pkgs.callPackage ../packages/jb-post-update { };
in
{
  home.packages =
    jetbrainsPackages
    ++ (with pkgs; [
      direnv
      nix-direnv
      nixfmt
      nixfmt-tree

      pkgsUnstable.jetbrains.jdk
      pkgsUnstable.postman

      jetbrainsPostUpdate
    ]);

  home.activation.runJetBrainsPostUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    state_dir="${config.xdg.stateHome}/jetbrains"
    previous_manifest="$state_dir/products.manifest"
    current_manifest="${jetbrainsManifest}"

    mkdir -p "$state_dir"

    if [ ! -f "$previous_manifest" ] || ! cmp -s "$current_manifest" "$previous_manifest"; then
      if ! ${lib.getExe jetbrainsPostUpdate}; then
        echo "JetBrains post-update script failed: ${lib.getExe jetbrainsPostUpdate}" >&2
      fi

      install -m 0644 "$current_manifest" "$previous_manifest"
    fi
  '';

  programs = {
    vscode = {
      enable = true;
      package = pkgsUnstable.vscode;

      profiles.default = {
        extensions = with pkgsUnstable.vscode-extensions; [
          bmewburn.vscode-intelephense-client
          xdebug.php-debug
          yzhang.markdown-all-in-one
          davidanson.vscode-markdownlint
          jnoortheen.nix-ide
          rooveterinaryinc.roo-cline
          streetsidesoftware.code-spell-checker
        ];
      };
    };
  };
}
