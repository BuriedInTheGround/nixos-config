# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes.
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit the number of generations to prevent the boot partition running out
  # of space.
  boot.loader.systemd-boot.configurationLimit = 15;

  networking.hostName = "glicine"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Enables NetworkManager.

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Set the location.
  location = {
    latitude = 45.4799;
    longitude = 11.9872;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp8s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


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

      # Enable BSPWM and LightDM.
      displayManager = {
        defaultSession = "none+bspwm";
        lightdm.enable = true;
      };
      windowManager.bspwm = {
        enable = true;
        configFile = "/etc/nixos/config/bspwm/bspwmrc";
	sxhkd.configFile = "/etc/nixos/config/sxhkd/sxhkdrc";
      };
    };
  };


  # Configure keymap in X11.
  services.xserver.layout = "us,it";
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp,eurosign:e,grp:alt_space_toggle";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      DiscoverableTimeout = 0;
      FastConnectable = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account.
  users.users.simone = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    home = "/home/simone";
    group = "users";
    uid = 1000;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    vim
    wget
    firefox
    pciutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

