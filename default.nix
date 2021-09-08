{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;

{
  # Import Home Manager NixOS Module and all modules under `./modules`.
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ] ++ (mapModulesRec' import ./modules);

  # Allow unfree packages from nixpkgs.
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # Enable Nix Flakes.
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set Nix store auto-optimization.
  nix.autoOptimiseStore = true;

  # Use the latest kernel.
  boot.kernelPackages = mkDefault pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  # Limit the number of generations to prevent the boot partition running out
  # of space.
  boot.loader.systemd-boot.configurationLimit = mkDefault 15;

  # Install some basic packages in the system profile.
  environment.systemPackages = with pkgs; [
    git
    gnumake
    pciutils
    psmisc
    unzip
    vim
    wget

    # Set https://github.com/uutils/coreutils as a replacement of the original
    # GNU coreutils.
    (unstable.uutils-coreutils.override { prefix = ""; })
  ];

  # Set the configurationRevision to the Git revision of this repository.
  #
  # TODO: maybe set it to be mandatory and throw an error if the Git tree is
  # dirty.
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
