# --------------------------------------------------------------
#
# Author:     Simone Ragusa <hi@interrato.dev>
# Repository: https://github.com/BuriedInTheGround/nixos-config
# License:    MIT
#
# --------------------------------------------------------------

{
  description = "BuriedInTheGround's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs:
    let
      inherit (lib.my) mapModulesRec mapHosts;

      system = "x86_64-linux";

      # Configure pkgs and apply overlays.
      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays;
      };
      pkgs = mkPkgs nixpkgs [ self.overlay ]; # (3) Set the overlay with unstable.
      pkgs' = mkPkgs nixpkgs-unstable []; # (1) Make the unstable.

      # Extend the standard nixpkgs/lib with my lib located at `./lib`.
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs pkgs;
          lib = self;
        };
      });
    in {
      overlay = final: prev: {
        unstable = pkgs'; # (2) Create the overlay with unstable.
      };

      # Uncomment the following line to expose the modules of this repository.
      # nixosModules = mapModulesRec import ./modules;

      nixosConfigurations = mapHosts ./hosts { };
    };
}
