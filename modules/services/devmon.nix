{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.devmon;
in {
  options.modules.services.devmon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.udevil ];

    services.devmon.enable = true;

    systemd.user.services."devmon" = {
      environment = {
        CMD1 = ''"${config.my.dir}/bin/devmon/set_last_mount %%d"'';
        CMD2 = ''"${config.my.dir}/bin/devmon/notify_mount %%l %%d"'';
      };
      path = [ pkgs.libnotify ];
      serviceConfig = {
        ExecStart = mkForce ''
          ${pkgs.udevil}/bin/devmon --sync \
                                    --exec-on-drive $CMD1 \
                                    --exec-on-drive $CMD2
        '';
      };
    };
  };
}
