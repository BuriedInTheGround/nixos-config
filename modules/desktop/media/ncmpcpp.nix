{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.media.ncmpcpp;
  configDir = config.my.configDir;
in {
  options.modules.desktop.media.ncmpcpp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (ncmpcpp.override {
        visualizerSupport = true;
      })
    ];

    home.configFile = {
      "ncmpcpp" = {
        source = "${configDir}/ncmpcpp";

        # Match the directory structure of `${configDir}/ncmpcpp` and symlink
        # only leaf nodes (files).
        recursive = true;
      };
    };
  };
}
