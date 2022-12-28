{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.virt;
in {
  options.modules.hardware.virt = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Enable libvirtd.
    virtualisation.libvirtd.enable = true;

    # Enable the user to manage VMs.
    user.extraGroups = [ "libvirtd" ];

    # Enable IP forward to use IPv4 NAT networking.
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    user.packages = with pkgs; [
      virt-manager
      virt-viewer
    ];
  };
}
