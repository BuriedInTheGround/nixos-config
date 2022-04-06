{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.office.teams;
in {
  options.modules.desktop.office.teams = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Microsoft Teams
    user.packages = [ pkgs.teams ];
  };
}
