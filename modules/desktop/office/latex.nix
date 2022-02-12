{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.office.latex;
in {
  options.modules.desktop.office.latex = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.tectonic ];
  };
}
