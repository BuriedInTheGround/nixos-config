{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.tree;
in {
  options.modules.shell.tree = {
    enable = mkBoolOpt false;
    useModern = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf (!cfg.useModern) tree)
    ];

    modules.shell.eza = mkIf cfg.useModern {
      enable = mkForce true;
    };

    environment.shellAliases = mkIf cfg.useModern {
      tree = "eza --tree";
    };
  };
}
