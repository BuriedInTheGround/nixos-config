{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.top;
in {
  options.modules.shell.top = {
    default = mkOpt "top" types.str;
    enableHtop = mkBoolOpt false;
    enableZenith = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.enableHtop htop)
      (mkIf cfg.enableZenith zenith)
    ];

    environment.shellAliases = {
      top = cfg.default;
    };
  };
}
