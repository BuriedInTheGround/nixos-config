{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.direnv ];

    # Add the direnv hook for Zsh.
    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';
  };
}
