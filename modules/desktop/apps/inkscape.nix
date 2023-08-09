{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.apps.inkscape;
in {
  options.modules.desktop.apps.inkscape = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.inkscape-with-extensions ];
  };
}
