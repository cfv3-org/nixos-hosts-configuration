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
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.05" ];
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
