{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.keychain;
in {
  options.modules.services.keychain = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.keychain ];
  };
}
