{
  description = "BuriedInTheGround's NixOS configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.glicine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/glicine/configuration.nix ];
    };

  };
}
