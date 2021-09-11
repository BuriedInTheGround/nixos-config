{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.develop.shell;
in {
  options.modules.develop.shell = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.shellcheck ];
  };
}
