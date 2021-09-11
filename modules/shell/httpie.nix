{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.httpie;
in {
  options.modules.shell.httpie = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.httpie ];
  };
}
