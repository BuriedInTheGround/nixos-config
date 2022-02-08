{ options, config, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
      startWhenNeeded = true;
    };

    programs.ssh.extraConfig = ''
      Host github.com
        AddKeysToAgent yes
    '';

    # TODO(note to self): make a new key using ed25519, it's way shorter and
    # also faster (and remember to update it on GitHub, please).
    user.openssh.authorizedKeys.keys =
      if config.user.name == "simone"
      then [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDE03Cds7BuOY0ySuP8rFgtMrM95aDEH0XrTjZa8czDfUzLi/TNx0k71bS4H8sus3fRP+8bXi6PlKiSo+YNApKJAxW7ZVLvNT04nFALExBHbdKM8PsXuCJg/WUEABEeAmBp/FolBcebjYRpNt/EahTgwZhAL2EnyD/9v8HExunIi9sGjZxd3KRBb6B+jubQiZY+6ZUWU1x8HArwsV1zpdyMCPzSpXwdUFx1FfiDqrwVeyM1blab17gd0Nc7Ap+Rm/KQXnuyOe6Egnsu1X/BKx+Xn2lxARoIarO2H89O4Jm0DbqS2OLjj3GuTBcB84uBUsJkC5PfrREbqNsU2D2QlGavh4O8LnHAUctwYuWBuzdjjdhWlmV7CTmJ7Fye0auQGJ4PL90ZAzWb7fVJnKQmsb/0Lm50pQAbf+SF1MVf9Ht2g927/67sLz7LMZZj7XsIuNJu0g3eXEEpLO6Xzp218JsbEtFXmDbkOFIzxCCY/D3mDVedOXbNT2vqTrJXTcFACNOCR9cAQGpGjg4MNXK963yshJaHcDDpL8P3FzIC4XQDYmf677slaPmX9jX6pq8SFTJSt+RXj/uop3wMq4JXu+vojTg3Z2l0hZheBbe/LJ97WRJ6lHOvI3Qv3BgzEmvi2eXnkJkeR4c8GvH5k+HGt1FnjC6kuOrAInM9PAv/lVJokw== simone99.as@gmail.com" ]
      else [];
  };
}
