{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.zsh;
  configDir = config.my.configDir;
in {
  options.modules.shell.zsh = {
    enable = mkBoolOpt false;

    rcInit = mkOpt' "" ''
      Zsh lines to be written to `$XDG_CONFIG_HOME/zsh/extra.zshrc` and sourced
      by `$XDG_CONFIG_HOME/zsh/.zshrc`.
    '' types.lines;

    rcFiles = with types; mkOpt [] (listOf (either str path));
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableGlobalCompInit = false; # A custom compinit must be made.
      promptInit = "";
    };

    user.packages = with pkgs; [
      zsh
      nix-zsh-completions
    ];

    env = {
      ZDOTDIR              = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE            = "$XDG_CACHE_HOME/zsh";
      ZGEN_DIR             = "$XDG_DATA_HOME/zsh";
      ZGEN_SOURCE          = "$ZGEN_DIR/zgen.zsh";
      ZGEN_RESET_ON_CHANGE = "$ZDOTDIR/.zshrc";
    };

    home.configFile = {
      "zsh" = {
        source = "${configDir}/zsh";

        # Match the directory structure of `${configDir}/zsh` and symlink only
        # leaf nodes (files).
        recursive = true;
      };

      "zsh/extra.zshrc".text = ''
        ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
        ${cfg.rcInit}
      '';
    };

    # Clean up Zsh cache.
    system.userActivationScripts.cleanUpZgen = ''
      rm -rfv $XDG_CACHE_HOME/zsh/*
    '';
  };
}
