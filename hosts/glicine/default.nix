{ config, lib, pkgs, ... }:

with lib.my;

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  modules = {
    desktop = {
      apps.flameshot.enable = true;
      apps.pavuc.enable = true;
      apps.rofi.enable = true;
      apps.telegram.enable = true;
      browsers.firefox.enable = true;
      bspwm.enable = true;
      media.mpv.enable = true;
      media.ncmpcpp.enable = true;
      media.nomacs.enable = true;
      media.spotify.enable = true;
      office.latex.enable = true;
      office.zathura.enable = true;
      polybar.enable = true;
      term.alacritty = {
        enable = true;
        isDefault = true;
      };
      xsecurelock.enable = true;
    };

    develop.gcc.enable = true;
    develop.go.enable = true;
    develop.node.enable = true;
    develop.shell.enable = true;

    editors.vim = {
      enable = true;
      supportLSP = [ "bash" "go" "svelte" ]; # No `nix` for now, as it's too slow.
      supportTreesitter = [ "bash" "go" "nix" "svelte" "yaml" ];
    };

    hardware.amd.enable = true;
    hardware.audio.enable = true;
    hardware.bluetooth = {
      enable = true;
      audio.enable = true;
    };
    hardware.filesystems.enable = true;
    hardware.sensors.enable = true;

    services.devmon.enable = true;
    services.dunst.enable = true;
    services.keychain.enable = true;
    services.mpd.enable = true;
    services.ssh.enable = true;

    shell.bat.enable = true;
    shell.cava.enable = true;
    shell.cmatrix.enable = true;
    shell.direnv.enable = true;
    shell.dog.enable = true;
    shell.duf.enable = true;
    shell.dust.enable = true;
    shell.exa.enable = true;
    shell.fd.enable = true;
    shell.ffmpeg.enable = true;
    shell.fzf.enable = true;
    shell.git.enable = true;
    shell.gping.enable = true;
    shell.neofetch.enable = true;
    shell.pastel.enable = true;
    shell.procs.enable = true;
    shell.qalc.enable = true;
    shell.rg.enable = true;
    shell.top = {
      enable = true;
      enableHtop = true;
      enableZenith = true;
      default = "zenith";
    };
    shell.tree = {
      enable = true;
      useModern = true;
    };
    shell.ytdl.enable = true;
    shell.zsh.enable = true;
  };

  # Enables NetworkManager.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp8s0.useDHCP = true;

  # Enable the user to use NetworkManager.
  user.extraGroups = [ "networkmanager" ];

  # Open some TCP ports for web development.
  networking.firewall.allowedTCPPorts = [ 3000 5000 8000 ];
}
