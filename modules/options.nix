{ options, config, lib, home-manager, ... }:

with lib;
with lib.my;

{
  options = {
    # User core settings and infos.
    user = mkOpt {} types.attrs;

    # Links to directories of this repository.
    my = {
      # Where the repository is located locally: `/etc/nixos`.
      dir        = mkOpt "/etc/nixos"               types.path;
      # Other relative paths.
      configDir  = mkOpt "${config.my.dir}/config"  types.path;
      modulesDir = mkOpt "${config.my.dir}/modules" types.path;
    };

    # Aliases to Home Manager handled user folders.
    home = {
      file       = mkOpt' {} "Files to place directly in $HOME"   types.attrs;
      configFile = mkOpt' {} "Files to place in $XDG_CONFIG_HOME" types.attrs;
      dataFile   = mkOpt' {} "Files to place in $XDG_DATA_HOME"   types.attrs;
    };

    # Environment variables accumulator.
    env = with types; mkOption {
      apply = mapAttrs (n: v:
        if isList v then concatMapStringsSep ":" (x: toString x) v
        else (toString v));
      default = {};
      description = "Environment variables.";
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
    };
  };

  config = {
    # User basic configuration.
    user = let
      name = "simone";
    in {
      inherit name;
      description = "${name}";
      extraGroups = [ "wheel" ];
      group = "users";
      home = "/home/${name}";
      isNormalUser = true;
      uid = 1000;
    };

    home-manager = {
      # Install packages to `/etc/profiles` instead of `$HOME/.nix-profile`.
      # See https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module.
      useUserPackages = true;

      # Set some aliases for less typing.
      #   home.file       -> home-manager.users.simone.home.file
      #   home.configFile -> home-manager.users.simone.xdg.configFile
      #   home.dataFile   -> home-manager.users.simone.xdg.dataFile
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;

          # Set the Home Manager stateVersion the same as system stateVersion
          # so that it works correctly with Nix Flakes.
          stateVersion = config.system.stateVersion; # (See default.nix).
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    # Set an alias for the user account.
    #   user -> users.users.simone
    users.users.${config.user.name} = mkAliasDefinitions options.user;

    # The $PATH to export after environment.variables and all profileVariables
    # are set.
    env.PATH = [ "$XDG_BIN_HOME" "$PATH" ];

    # This results in something like:
    #
    #   export PATH="$XDG_BIN_HOME:$PATH"
    #   export ....
    #   export ....
    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
