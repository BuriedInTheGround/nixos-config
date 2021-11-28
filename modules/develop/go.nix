{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.develop.go;
in {
  options.modules.develop.go = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.unstable.go_1_17 ]; # TODO: update when possible.

    # Ensure that Go installed local binaries are accessible through PATH.
    env.GOPATH = "$(go env GOPATH)";
    env.PATH = [ "$GOPATH/bin" ];
  };
}
