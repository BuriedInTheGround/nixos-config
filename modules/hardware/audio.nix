{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    # Add CLI utility to control media players that implement MPRIS.
    user.packages = [ pkgs.playerctl ];

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;

      # Automatically switch audio to the newer connected device.
      extraConfig = ''
        load-module module-switch-on-connect
      '';

      # Enable realtime scheduling.
      daemon.config = {
        realtime-scheduling = "yes";
      };
    };

    # Add the user to the `audio` group.
    user.extraGroups = [ "audio" ];
  };
}
