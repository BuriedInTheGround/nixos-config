{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.git;
  configDir = config.my.configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Note: git itself is already installed system-wide (see `default.nix` in
    # the root directory).
    user.packages = with pkgs; [
      git-revise
      gitAndTools.diff-so-fancy
      gitAndTools.git-open
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
    };

    # Load aliases that uses the `git` command (in-git aliases should be in the
    # placed `git/config` file).
    modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
