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
      exfat   # ex-FAT file system implementation.
      fuse    # Linux FUSE (Filesystem in Userspace) interface.
      jmtpfs  # For MTP devices like Android phones.
      ntfs3g  # FUSE-based NTFS driver with full write support.
    ];
  };
}
