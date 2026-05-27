{
  description = "NixOS flake config — webdev4";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    system = "x86_64-linux";
    pkgs   = nixpkgs.legacyPackages.${system};
  in {
    overlays         = import ./overlays { inherit inputs; };
    nixosModules     = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs    = true;
          home-manager.useUserPackages  = true;
        }
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
