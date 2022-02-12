{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.rip;
in {
  options.modules.shell.rip = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.rm-improved ];
  };
}
