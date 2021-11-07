{ config, lib, pkgs, ... }:

with lib;
with lib.my;

{
  config = {
    user.packages = with pkgs; [
      # To control brightness (e.g. for laptops).
      brightnessctl

      # To set a wallpaper.
      feh
    ];

    fonts = {
      # Create a directory with links to all fonts
      # in `/run/current-system/sw/share/X11/fonts`.
      fontDir.enable = true;

      # Add fonts provided by Ghostscript and make them available to X11 apps.
      enableGhostscriptFonts = true;

      # Add fonts.
      fonts = with pkgs; [
        dejavu_fonts
        font-awesome
        ibm-plex
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        (unstable.iosevka.override {
          privateBuildPlan = ''
            [buildPlans.iosevka-term]
            family = "Iosevka Term"
            spacing = "term"
            serifs = "sans"
            no-cv-ss = true
          '';
          set = "term";
        })
        (nerdfonts.override {
          fonts = [ "DejaVuSansMono" ];
        })
      ];

      # Enable font antialiasing and set default fonts.
      fontconfig = {
        enable = true;
        antialias = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Iosevka Term Extended"
            "Noto Color Emoji"
            "DejaVuSansMono Nerd Font"
            "DejaVu Sans Mono"
          ];
          sansSerif = [ "DejaVu Sans" ];
          serif = [ "DejaVu Serif" ];
        };
      };
    };

    # Enable dconf configuration system and settings management tool.
    programs.dconf.enable = true;

    # Clean up $HOME.
    system.userActivationScripts.cleanUpHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
