{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.develop.flyctl;
in {
  options.modules.develop.flyctl = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.flyctl ];
  };
}
