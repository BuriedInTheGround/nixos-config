{ options, config, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Add the user to the `audio` group.
    user.extraGroups = [ "audio" ];
  };
}
