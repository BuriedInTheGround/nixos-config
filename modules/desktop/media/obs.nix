{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.media.obs;
in {
  options.modules.desktop.media.obs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.obs-studio ];
  };
}
