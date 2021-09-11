{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.fd;
in {
  options.modules.shell.fd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.fd ];
  };
}
