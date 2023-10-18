{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.office.onlyoffice;
in {
  options.modules.desktop.office.onlyoffice = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.onlyoffice-bin_latest ];
  };
}
