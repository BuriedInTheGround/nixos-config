{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.apps.signal;
in {
  options.modules.desktop.apps.signal = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Make sure to be using an unstable channel because after a certain amount
    # of time Signal complains that the version is too low a stops working.
    user.packages = [ pkgs.signal-desktop ];
  };
}
