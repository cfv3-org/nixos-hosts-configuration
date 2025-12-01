{
  description = "Vasary NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.05" ];
        };
      };

      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        workstation = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            userName = "vasary";
          };
          modules = [
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
          inherit system pkgs;
          specialArgs = {
            userName = "vasary";
          };
          modules = [
            (
              { ... }:
              {
                _module.args.pkgsUnstable = pkgsUnstable;
              }
            )
            ./hosts/t1/configuration.nix

            home-manager.nixosModules.home-manager
            (
              { userName, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit userName pkgsUnstable; };
                  users.${userName} = import ./home/users/${userName}/workstation.nix;
                };
              }
            )
          ];
        };
      };
    };
}
