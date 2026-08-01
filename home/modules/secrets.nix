{ pkgs, ... }:

let
  sopsEnv = ''
    set -eu

    find_sops_config() {
      dir=$(pwd -P)

      while :; do
        for name in .sops.yaml .sops.yml .sops; do
          if [ -f "$dir/$name" ]; then
            printf '%s/%s\n' "$dir" "$name"
            return 0
          fi
        done

        parent=''${dir%/*}
        if [ "$parent" = "$dir" ] || [ -z "$parent" ]; then
          return 1
        fi
        dir=$parent
      done
    }

    if [ "$#" -ne 1 ]; then
      printf 'Usage: %s <file>\n' "''${0##*/}" >&2
      exit 64
    fi

    file=$1
    config=$(find_sops_config || true)

    if [ -n "$config" ]; then
      export SOPS_CONFIG=$config
    fi

    if [ -z "''${SOPS_AGE_KEY:-}" ] && [ -z "''${SOPS_AGE_KEY_FILE:-}" ]; then
      age_key_file="''${XDG_CONFIG_HOME:-$HOME/.config}/sops/age/keys.txt"
      if [ -f "$age_key_file" ]; then
        export SOPS_AGE_KEY_FILE=$age_key_file
      fi
    fi
  '';

  sopsEdit = pkgs.writeShellScriptBin "sops-edit" ''
    ${sopsEnv}

    export SOPS_EDITOR=${pkgs.vim}/bin/vim
    export EDITOR=${pkgs.vim}/bin/vim
    exec ${pkgs.sops}/bin/sops "$file"
  '';

  sopsOpen = pkgs.writeShellScriptBin "sops-open" ''
    ${sopsEnv}

    if [ -t 1 ]; then
      ${pkgs.sops}/bin/sops --decrypt "$file" | "''${PAGER:-${pkgs.less}/bin/less}"
    else
      exec ${pkgs.sops}/bin/sops --decrypt "$file"
    fi
  '';
in

{
  home.packages = [
    pkgs.age
    pkgs.sops
    sopsEdit
    sopsOpen
  ];
}
