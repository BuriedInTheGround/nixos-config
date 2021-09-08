{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.term;
in {
  options.modules.desktop.term = {
    default = mkOpt "xterm" types.str;
  };

  config = {
    # If "xterm" is the default chosen terminal, enable the service.
    services.xserver.desktopManager.xterm.enable =
      mkDefault (cfg.default == "xterm");

    # Set the TERMINAL environment variable to the default chosen one.
    env.TERMINAL = cfg.default;
  };
}
