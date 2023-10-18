{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;

let
  sys = "x86_64-linux";
in {

  /* Generate a NixOS Configuration attribute set from a path to a folder
     containing a default.nix file with the actual configuration, or from an
     individual file with a configuration.

     Type: mkHost :: FilePath -> AttrSet -> AttrSet
  */
  mkHost = path: { system ? sys, ... } @ attrs:
    nixosSystem {
      inherit system;
      modules = [
        {
          nixpkgs.pkgs = pkgs; # Point pkgs to the pkgs input received.

          # Set the hostname based on the directory name, if it contains a
          # default.nix, or the file name (a non default.nix file containing a
          # configuration).
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }

        inputs.nixos-hardware.nixosModules.common-gpu-amd-southern-islands

        # Insert every other attribute except "system" (which is already
        # inherited outside).
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)

        # Insert from default.nix in the root directory of this repository,
        # there should be a basic configuration in it.
        ../.

        # Insert the actual configuration (from `<hostname-dir>/default.nix` or
        # from `<hostname-file>.nix`).
        (import path)
      ];
      specialArgs = { inherit inputs lib system; };
    };

  /* Generate an attribute set of hosts configurations by mapping the mkHost
     function to the content of a directory. The specified directory should
     contain one directory for each host with a default.nix file of the actual
     configuration.

     Type: mapHosts :: DirPath -> AttrSet -> AttrSet
  */
  mapHosts = dir: { system ? sys, ... } @ attrs:
    mapModules
      (hostPath: mkHost hostPath attrs) dir;

}
