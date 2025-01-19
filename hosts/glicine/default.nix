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
      apps.anki.enable = true;
      apps.flameshot.enable = true;
      apps.gimp.enable = true;
      apps.inkscape.enable = true;
      apps.pavuc.enable = true;
      apps.rofi.enable = true;
      browsers.chromium.enable = true;
      browsers.firefox.enable = true;
      bspwm.enable = true;
      media.droidcam.enable = true;
      media.mpv.enable = true;
      media.ncmpcpp.enable = true;
      office.latex.enable = true;
      office.lockbook.enable = true;
      office.okular.enable = true;
      office.onlyoffice.enable = true;
      office.zathura.enable = true;
      office.zoom.enable = true;
      polybar.enable = true;
      term.alacritty = {
        enable = true;
        isDefault = true;
      };
      term.tmux.enable = true;
      xsecurelock.enable = true;
    };

    develop.flyctl.enable = true;
    develop.gcc.enable = true;
    develop.go.enable = true;
    develop.node.enable = true;
    develop.shell.enable = true;

    editors.neovim = {
      enable = true;
      vimAlias = true;
    };

    hardware.audio.enable = true;
    hardware.bluetooth = {
      enable = true;
      audio.enable = true;
    };
    hardware.filesystems.enable = true;
    hardware.sensors.enable = true;
    hardware.virt.enable = true;

    services.docker.enable = true;
    services.dunst.enable = true;
    services.keychain.enable = true;
    services.mpd.enable = true;
    services.ssh.enable = true;
    services.syncthing.enable = true;

    shell.adb.enable = true;
    shell.age.enable = true;
    shell.bat.enable = true;
    shell.cava.enable = true;
    shell.cmatrix.enable = true;
    shell.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    shell.duf.enable = true;
    shell.dust.enable = true;
    shell.eza.enable = true;
    shell.exiftool.enable = true;
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
      default = "htop";
    };
    shell.tree = {
      enable = true;
      useModern = true;
    };
    shell.ytdl.enable = true;
    shell.zsh.enable = true;
  };

  # Enables NetworkManager.
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
  };

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
