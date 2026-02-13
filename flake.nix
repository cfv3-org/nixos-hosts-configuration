{
  description = "Vasary NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      rust-overlay,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      baseModule =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [
            rust-overlay.overlays.default
          ];

          nixpkgs.config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "ventoy-1.1.07"
            ];
          };
        };

    in
    {
      nixosConfigurations = {
        workstation = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            userName = "vasary";
          };

          modules = [
            baseModule
            ./hosts/ms01/configuration.nix

            home-manager.nixosModules.home-manager
            (
              { userName, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit userName; };

                  users.${userName} = import ./home/users/${userName}/workstation.nix;
                };
              }
            )
          ];
        };

        t1 = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            userName = "vasary";
          };

          modules = [
            baseModule
            (
              { pkgs, ... }:
              let
                pkgsUnstable = import nixpkgs-unstable {
                  inherit (pkgs) system;
                  config.allowUnfree = true;
                };
              in
              {
                _module.args.pkgsUnstable = pkgsUnstable;
              }
            )

            ./hosts/t1/configuration.nix

            home-manager.nixosModules.home-manager
            (
              { userName, pkgsUnstable, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;

                  extraSpecialArgs = {
                    inherit userName pkgsUnstable;
                  };

                  users.${userName} = import ./home/users/${userName}/workstation.nix;
                };
              }
            )
          ];
        };
      };
    };
}
