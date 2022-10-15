{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.xsecurelock;
  mpvCfg = config.modules.desktop.media.mpv;
in {
  options.modules.desktop.xsecurelock = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # If mpv is installed make sure that XSecureLock generate the saver_mpv
      # script.
      (mkIf mpvCfg.enable (xsecurelock.overrideAttrs (oldAttrs: rec {
        configureFlags = [
          "--with-pam-service-name=login"
          "--with-mpv=${pkgs.mpv}/bin/mpv"
        ];
      })))

      # Otherwise just install it.
      (mkIf (!mpvCfg.enable) xsecurelock)
    ];

    # Picom isn't 100% supported by XSecureLock and needs to use "glx" as
    # backend to not show the message "INCOMPATIBLE COMPOSITOR, PLEASE FIX!".
    services.picom = {
      backend = mkForce "glx";
      settings = {
        glx-no-stencil = true;
      };
    };
  };
}
