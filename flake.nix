{
  description = "Vasary NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      rust-overlay,
      sops-nix,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      mkPkgsUnstable =
        system:
        import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "electron-39.8.10"
            ];
          };
          overlays = [
            (_final: prev: {
              openldap = prev.openldap.overrideAttrs (_old: {
                doCheck = false;
              });
            })
          ];
        };

      baseModule =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [
            rust-overlay.overlays.default
          ];

          nixpkgs.config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "ventoy-1.1.12"
            ];
          };
        };

      mkHomeManagerModule =
        extraSpecialArgs:
        { userName, ... }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            inherit extraSpecialArgs;

            users.${userName} = import ./home/users/${userName}/workstation.nix;
          };
        };

      mkHost =
        {
          hostModule,
          userName,
          extraModules ? [ ],
          extraHomeArgs ? { },
        }:
        let
          pkgsUnstable = mkPkgsUnstable system;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit userName pkgsUnstable;
          };

          modules = [
            baseModule
            sops-nix.nixosModules.sops
            (./modules/users + "/${userName}/default.nix")
          ]
          ++ extraModules
          ++ [
            hostModule
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule (
              {
                inherit userName pkgsUnstable;
              }
              // extraHomeArgs
            ))
          ];
        };

    in
    {
      nixosConfigurations = {
        t1 = mkHost {
          hostModule = ./hosts/t1/configuration.nix;
          userName = "vasary";
        };
      };
    };
}
