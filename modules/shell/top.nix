{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.top;
in {
  options.modules.shell.top = {
    enable = mkBoolOpt false;
    enableHtop = mkBoolOpt false;
    enableZenith = mkBoolOpt false;
    default = mkOpt "top" types.str;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.enableHtop htop)
      (mkIf cfg.enableZenith zenith)
    ];

    environment.shellAliases = {
      top = cfg.default;
    };
  };
}
