{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.bat;
in {
  options.modules.shell.bat = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.bat ];

    # Apply `Nord` theme to Bat.
    env.BAT_THEME = "Nord";
  };
}
