{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.develop.node;
in {
  options.modules.develop.node = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.nodejs ];

    # Make NPM and Node.js comply with the XDG standard.
    env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
    env.NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
    env.NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    env.NPM_CONFIG_PREFIX = "$XDG_DATA_HOME/npm";
    env.NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";

    home.configFile."npm/config".text = ''
      cache=$XDG_CACHE_HOME/npm
      prefix=$XDG_DATA_HOME/npm
    '';
  };
}
