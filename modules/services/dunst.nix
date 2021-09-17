{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.dunst;
  configDir = config.my.configDir;
in {
  options.modules.services.dunst = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      dunst
      libnotify
    ];

    home.configFile = {
      "dunst" = {
        source = "${configDir}/dunst";

        # Match the directory structure of `${configDir}/dunst` and symlink
        # only leaf nodes (files).
        recursive = true;
      };
    };
  };
}
