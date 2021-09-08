{ config, lib, pkgs, ... }:

with lib;
with lib.my;

{
  config = {
    user.packages = with pkgs; [ feh xclip ];

    fonts = {
      # Create a directory with links to all fonts in `/run/current-system/sw/share/X11/fonts`.
      fontDir.enable = true;

      # Add fonts provided by Ghostscript and make them available to X11 apps.
      enableGhostscriptFonts = true;

      # Add fonts.
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        # noto-fonts-emoji
        # noto-fonts-extra
        (unstable.nerdfonts.override {
          fonts = [
            "DejaVuSansMono"
            # "DroidSansMono"
            # "FiraCode"
            # "Meslo"
            "SourceCodePro"
          ];
        })
      ];
    };

    # Clean up $HOME.
    system.userActivationScripts.cleanUpHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
