{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.firefox ];

    # Comply with the XDG standard.
    # See https://bugzilla.mozilla.org/show_bug.cgi?id=1082717.
    env.XDG_DESKTOP_DIR = "$HOME/";
  };
}
