{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.apps.rofi;
  configDir = config.my.configDir;
in {
  options.modules.desktop.apps.rofi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.pkgs.rofi

      (writeScriptBin "myrofi" ''
        #!${stdenv.shell}
        exec ${unstable.pkgs.rofi}/bin/rofi -monitor -1 \
                                            -matching fuzzy \
                                            -no-fixed-num-lines "$@"
      '')
    ];

    home.configFile = {
      "rofi" = {
        source = "${configDir}/rofi";

        # Match the directory structure of `${configDir}/rofi` and symlink only
        # leaf nodes (files).
        recursive = true;
      };
    };
  };
}
