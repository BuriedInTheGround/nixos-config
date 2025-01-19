{ options, config, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.docker;
in {
  options.modules.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
      daemon.settings = {
        data-root = "/run/media/simone/HardDisk/dckr";
      };
      storageDriver = "overlay2";
    };

    user.extraGroups = [ "docker" ];
  };
}
