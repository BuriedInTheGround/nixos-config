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
      user.packages = with pkgs; [
        unstable.alacritty
      ];

      home.configFile."alacritty/alacritty.yml".source =
        "${configDir}/alacritty/alacritty.yml";
    }

    (mkIf cfg.isDefault {
      modules.desktop.term.default = "alacritty";
      env.COLORTERM = "truecolor";
    })
  ]);
}
