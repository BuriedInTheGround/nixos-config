{ config, home-manager, ... }:

{
  # Enable XDG and automatic creation of XDG user directories.
  home-manager.users.${config.user.name}.xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
  };

  environment = {
    # Set the XDG environment variables.
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };

    # Move the ~/.Xauthority X cookie file out of the $HOME directory.
    extraInit = ''
      export XAUTHORITY=/tmp/Xauthority
      [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
    '';
  };
}
