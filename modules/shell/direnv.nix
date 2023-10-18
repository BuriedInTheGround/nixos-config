{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {
    enable = mkBoolOpt false;
    nix-direnv.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.direnv ];

    # Add the direnv hook for Zsh.
    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    # Protect nix-shell against garbage collection.
    nix = let
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    in mkIf cfg.nix-direnv.enable { inherit extraOptions; };

    # Source the nix-direnv adapted rc file.
    home.configFile."direnv/direnvrc" = let
      text = ''
        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      '';
    in mkIf cfg.nix-direnv.enable { inherit text; };
  };
}
