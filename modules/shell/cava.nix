{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.cava;
  configDir = config.my.configDir;
in {
  options.modules.shell.cava = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.cava ];

    home.configFile."cava".source = "${configDir}/cava";
  };
}
