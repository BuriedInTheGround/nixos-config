{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.filesystems;
in {
  options.modules.hardware.filesystems = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Enable udevil for easier mounting.
    programs.udevil.enable = true;

    # Add support for more filesystems.
    environment.systemPackages = with pkgs; [
      fuse
      exfat
      ntfs3g
    ];
  };
}
