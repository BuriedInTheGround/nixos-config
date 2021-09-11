{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.apps.discord;
in {
  options.modules.desktop.apps.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Must use `unstable` to (try to) avoid Discord wanting to update.
    user.packages = [ pkgs.unstable.discord ];
  };
}
