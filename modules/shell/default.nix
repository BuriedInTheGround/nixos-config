{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  configDir = config.my.configDir;
in {
  config = {
    # Add core shell packages.
    user.packages = with pkgs; [
      bc
      jq
      xclip
    ];

    home.configFile = {
      # Add dir_colors source file.
      "dir_colors" = {
        source = "${configDir}/dir_colors";
      };
    };

    # Activate dircolors.
    modules.shell.zsh.rcInit = ''eval "$(dircolors $XDG_CONFIG_HOME/dir_colors)"'';

    env.PAGER = "less -R --mouse --wheel-lines 3";
  };
}
