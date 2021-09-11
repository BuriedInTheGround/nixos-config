{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.develop.gcc;
in {
  options.modules.develop.gcc = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.gcc ];
  };
}
