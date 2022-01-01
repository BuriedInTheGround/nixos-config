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
      apps.discord.enable = true;
      apps.flameshot.enable = true;
      apps.gimp.enable = true;
      apps.logseq.enable = true;
      apps.pavuc.enable = true;
      apps.rofi.enable = true;
      apps.telegram.enable = true;
      apps.wine.enable = true;
      browsers.firefox.enable = true;
      bspwm.enable = true;
      media.droidcam.enable = true;
      media.mpv.enable = true;
      media.ncmpcpp.enable = true;
      media.nomacs.enable = true;
      media.obs.enable = true;
      media.spotify.enable = true;
      media.yabridge.enable = true;
      office.latex.enable = true;
      office.libreoffice.enable = true;
      office.zathura.enable = true;
      office.zoom.enable = true;
      polybar.enable = true;
      term.alacritty = {
        enable = true;
        isDefault = true;
      };
      term.tmux = {
        enable = true;
        plugins = with pkgs.tmuxPlugins; [ nord ];
      };
      xsecurelock.enable = true;
    };

    develop.gcc.enable = true;
    develop.go.enable = true;
    develop.node.enable = true;
    develop.shell.enable = true;

    editors.vim = {
      enable = true;
      supportLSP = [
        "bash"
        "go"
        "latex"
        "nix"
        "svelte"
        "tailwindcss"
        "typescript"
        "vim"
      ];
      supportTreesitter = [
        "bash"
        "css"
        "go"
        "javascript"
        "json"
        "latex"
        "lua"
        "markdown"
        "nix"
        "svelte"
        "typescript"
        "vim"
        "yaml"
      ];
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
    shell.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    shell.dog.enable = true;
    shell.duf.enable = true;
    shell.dust.enable = true;
    shell.exa.enable = true;
    shell.fd.enable = true;
    shell.ffmpeg.enable = true;
    shell.fzf.enable = true;
    shell.git.enable = true;
    shell.gping.enable = true;
    shell.httpie.enable = true;
    shell.neofetch.enable = true;
    shell.parted.enable = true;
    shell.pastel.enable = true;
    shell.procs.enable = true;
    shell.qalc.enable = true;
    shell.rg.enable = true;
    shell.rip.enable = true;
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
