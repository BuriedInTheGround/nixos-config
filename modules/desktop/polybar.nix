{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.polybar;
  configDir = config.my.configDir;
in {
  options.modules.desktop.polybar = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (polybar.override {
        mpdSupport = true;
        nlSupport = true;
        pulseSupport = true;
      })
    ];

    home.configFile = {
      "polybar" = {
        source = "${configDir}/polybar";

        # Match the directory structure of `${configDir}/polybar` and symlink
        # only leaf nodes (files).
        recursive = true;
      };
    };
  };
}
