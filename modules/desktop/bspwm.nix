{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.bspwm;
  configDir = config.my.configDir;
in {
  options.modules.desktop.bspwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      # Enable Picom as the X.org composite manager.
      picom = {
        enable = true;
        fade = true;
        fadeDelta = 3;
      };

      # Enable unclutter to hide the mouse cursor when inactive.
      unclutter.enable = true;

      # Enable Redshift to change the screen's colour temperature depending on
      # the time of day.
      redshift.enable = true;

      xserver = {
        # Enable the X11 windowing system.
        enable = true;

        # Configure keymap in X11.
        layout = "us,it";
        xkbOptions = "terminate:ctrl_alt_bksp,eurosign:e,grp:alt_space_toggle";

        # Enable BSPWM and LightDM.
        displayManager = {
          defaultSession = "none+bspwm";
          lightdm.enable = true;
          lightdm.greeters.mini = {
            enable = true;
            user = "${config.user.name}";
            extraConfig = ''
              [greeter]
              # Whether to show the password input's label.
              show-password-label = true
              # The text of the password input's label.
              password-label-text = Password:
              # The text shown when an invalid password is entered. May be blank.
              invalid-password-text = Invalid Password
              # Show a blinking cursor in the password input.
              show-input-cursor = true
              # The text alignment for the password input. Possible values are:
              # "left", "center", or "right"
              password-alignment = right
              # Show the background image on all monitors or just the primary monitor.
              show-image-on-all-monitors = true

              [greeter-theme]
              # The default text color
              text-color = "#2E3440"
              # The color of the error text
              error-color = "#ECEFF4"

              # An absolute path to an optional background image.
              # The image will be displayed centered & unscaled.
              # Note: The file should be somewhere that LightDM has permissions to read
              #       (e.g., /etc/lightdm/).
              background-image = "${config.my.dir}/wallpapers/ign_colorful.png"

              # The screen's background color.
              background-color = "#3B4252"
              # The password window's background color.
              window-color = "#88C0D0"
              # The color of the password window's border
              border-color = "#2E3440"

              # The color of the text in the password input.
              password-color = "#ECEFF4"
              # The background color of the password input.
              password-background-color = "#3B4252"
              # The color of the password input's border.
              # Falls back to `border-color` if missing.
              password-border-color = "#2E3440"
            '';
          };
        };
        windowManager.bspwm = {
          enable = true;
          configFile = "${configDir}/bspwm/bspwmrc";
          sxhkd.configFile = "${configDir}/sxhkd/sxhkdrc";
        };
      };
    };
  };
}
