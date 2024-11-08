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

    # Enable PipeWire for sound.
    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Add the user to the `audio` group.
    user.extraGroups = [ "audio" "pipewire" ];
  };
}
