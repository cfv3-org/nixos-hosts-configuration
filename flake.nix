{
  description = "Vasary NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
#    nur.url = "github:nix-community/NUR";

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
#      nur,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
#        overlays = [ nur.overlay ];
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
            ./hosts/workstation/configuration.nix

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
      };
    };
}
