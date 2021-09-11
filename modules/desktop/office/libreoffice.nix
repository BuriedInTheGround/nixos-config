{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.office.libreoffice;
in {
  options.modules.desktop.office.libreoffice = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.libreoffice ];
  };
}
