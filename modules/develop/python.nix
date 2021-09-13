{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.develop.python;
in {
  options.modules.develop.python = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      python39
      python39Packages.pip
      python39Packages.setuptools
    ];

    environment.shellAliases = {
      py  = "python";
      py2 = "python2";
      py3 = "python3";
    };

    env = {
      IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";

      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";

      PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      PIP_LOG_FILE    = "$XDG_DATA_HOME/pip/log";

      PYLINTHOME = "$XDG_DATA_HOME/pylint";
      PYLINTRC   = "$XDG_CONFIG_HOME/pylint/pylintrc";

      PYTHONSTARTUP    = "$XDG_CONFIG_HOME/python/pythonrc";
      PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
    };
  };
}
