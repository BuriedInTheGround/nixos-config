{ options, config, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.pg;
in {
  options.modules.services.pg = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
    };
  };
}
