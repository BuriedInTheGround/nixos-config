{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.syncthing ];
  };
}
