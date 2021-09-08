{ config, lib, pkgs, ... }:

with lib.my;

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  modules = {
    desktop = {
      bspwm.enable = true;
      apps.pavuc.enable = true;
      browsers.firefox.enable = true;
      term.alacritty = {
        enable = true;
        isDefault = true;
      };
    };

    develop.gcc.enable = true;
    develop.go.enable = true;
    # develop.node.enable = true;
    # develop.shell.enable = true;

    hardware.amd.enable = true;
    hardware.audio.enable = true;
    hardware.bluetooth = {
      enable = true;
      audio.enable = true;
    };
    hardware.filesystems.enable = true;
    hardware.sensors.enable = true;

    services.ssh.enable = true;

    shell.neofetch.enable = true;
    shell.rg.enable = true;
    shell.top = {
      default = "zenith";
      enableHtop = true;
      enableZenith = true;
    };
  };

  # Enables NetworkManager.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp8s0.useDHCP = true;

  # Enable the user to use NetworkManager.
  user.extraGroups = [ "networkmanager" ];
}
