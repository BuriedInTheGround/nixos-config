{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.term.alacritty;
  configDir = config.my.configDir;
in {
  options.modules.desktop.term.alacritty = {
    enable = mkBoolOpt false;
    isDefault = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = [ pkgs.alacritty ];

      home.configFile."alacritty/alacritty.toml".source =
        "${configDir}/alacritty/alacritty.toml";
    }

    (mkIf cfg.isDefault {
      modules.desktop.term.default = "alacritty";
      env.COLORTERM = "truecolor";
    })
  ]);
}
