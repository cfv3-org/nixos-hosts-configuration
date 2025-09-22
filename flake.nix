{
  description = "Vasary NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        workstation = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            userName = "vasary";
          };
          modules = [
            ./hosts/workstation/configuration.nix

            home-manager.nixosModules.home-manager
            (
              { userName, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${userName} = import ./home/users/${userName}/workstation.nix;
                };
              }
            )
          ];
        };
      };
    };
}
