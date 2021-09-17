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
        package = pkgs.bluezFull;
        powerOnBoot = true;

        # Enable faster discoverability.
        settings.General = {
          DiscoverableTimeout = 0;
          FastConnectable = true;
        };
        settings.Policy.AutoEnable = true;
      };

      services.blueman.enable = true;
    }

    (mkIf cfg.audio.enable {
      # Enable PulseAudio bluetooth support for AAC, APTX, APTX-HD and LDAC.
      hardware.pulseaudio = {
        package = mkForce pkgs.pulseaudioFull;
        extraModules = [ pkgs.pulseaudio-modules-bt ];
      };

      # Enable the bluetooth A2DP profile to properly handle modern headsets.
      hardware.bluetooth.settings = {
        General.Enable = "Source,Sink,Media,Socket";
      };

      # Start a MPRIS Proxy service to control the media player using the
      # bluetooth headset buttons.
      systemd.user.services."mpris-proxy" = {
        enable = true;
        after = [ "bluetooth.target" ];
        bindsTo = [ "bluetooth.target" ];
        description = "MPRIS Proxy";
        serviceConfig = {
          ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
          Type = "simple";
        };
        wantedBy = [ "bluetooth.target" ];
      };
    })
  ]);
}
