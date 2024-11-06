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
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Add the user to the `audio` group.
    user.extraGroups = [ "audio" ];
  };
}
