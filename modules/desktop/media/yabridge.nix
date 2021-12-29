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

    # Add the specified folder to PATH: required when using `yabridgectl sync`.
    env.PATH = [ "/etc/profiles/per-user/${config.user.name}/lib" ];
  };
}
