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
      mkPkgsUnstable =
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
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
              "ventoy-1.1.10"
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
            inherit userName;
          };

          modules = [
            baseModule
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
          extraModules = [
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
          ];
          extraHomeArgs = {
            pkgsUnstable = mkPkgsUnstable system;
          };
        };
      };
    };
}
