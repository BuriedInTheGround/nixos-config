{ options, config, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    programs.ssh.extraConfig = ''
      Host github.com
        AddKeysToAgent yes
    '';

    user.openssh.authorizedKeys.keys =
      if config.user.name == "simone"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJF2oqWcVqQyM+KCV9oSMW/Rqy8gRZZgeY8TDbFb29T hi@interrato.dev" ]
      else [ ];
  };
}
