{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.media.yabridge;
in {
  options.modules.desktop.media.yabridge = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      yabridge
      yabridgectl
    ];

    # Enable RealtimeKit for on demand realtime scheduling of user processes.
    security.rtkit.enable = true;

    # Let users in audio group to execute realtime processes with no memory
    # limit.
    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type="-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio";  type="-"; value = "99"; }
      { domain = "@audio"; item = "nofile";  type="-"; value = "99999"; }
    ];

    # Add the specified folder to PATH: required when using `yabridgectl sync`.
    env.PATH = [ "/etc/profiles/per-user/${config.user.name}/lib" ];
  };
}
