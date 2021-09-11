{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.bluetooth;
in {
  options.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
    audio.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.bluetooth = {
        # Enable bluetooth.
        enable = true;
        powerOnBoot = true;

        # Enable faster discoverability.
        settings.General = {
          DiscoverableTimeout = 0;
          FastConnectable = true;
        };
        settings.Policy.AutoEnable = true;
      };
    }

    (mkIf cfg.audio.enable {
      # Enable PulseAudio bluetooth support.
      hardware.pulseaudio = {
        package = pkgs.pulseaudioFull;
        extraModules = [ pkgs.pulseaudio-modules-bt ];
      };

      # Set bluetooth to properly handle audio sources.
      hardware.bluetooth.settings = {
        General.Enable = "Source,Sink,Media,Socket";
      };
    })
  ]);
}
