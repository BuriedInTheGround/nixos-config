# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/common/cpu/intel>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Set a maximum number of latest generations.
  boot.loader.systemd-boot.configurationLimit = 5;

  # Set nix store auto-optimization and garbage collection.
  nix.autoOptimiseStore = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 180d";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Enables NetworkManager.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Nix Packages collection configuration.
  nixpkgs.config = {
    # Allow proprietary packages.
    allowUnfree = true;

    # Create an alias for the unstable channel.
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        # Pass the nixpkgs config to the unstable alias to ensure `allowUnfree = true;` is propagated.
        config = config.nixpkgs.config;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ##### Terminal & Shell Customization  #####
    oh-my-zsh
    zsh

    ##### Shell Tools #####
    acpi
    alsamixer.app
    binutils
    coreutils
    curl
    ffmpeg
    killall
    lm_sensors
    man
    man-pages
    mktemp
    nano
    neofetch
    parted
    posix_man_pages
    ripgrep
    wget
    xorg.xinit

    ##### GUI Tools #####
    gparted
    pavucontrol
    unstable.vscode

    ##### Archive Tools #####
    bzip2
    gzip
    lzma
    unrar
    unzip
    zip

    ##### Helpers #####
    fuse
    ntfs3g

    ##### Browsers #####
    chromium
    firefoxWrapper

    ##### Media #####
    lollypop
    mpv
    nomacs

    ##### Docker #####
    docker
    docker-compose
    docker-slim
  ];

  # Enable ZSH and set it as default shell.
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      customPkgs = [
        pkgs.zsh-you-should-use
      ];
      plugins = [ "you-should-use" ];
      theme = "robbyrussell";
    };
  };

  # Enable ADB.
  programs.adb.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Fonts.
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    (unstable.nerdfonts.override {
      fonts = [
        "DejaVuSansMono"
        "DroidSansMono"
        "FiraCode"
        "Meslo"
        "SourceCodePro"
      ];
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Seahorse and Gnome Keyring.
  programs.seahorse.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true; # Automatically unlock keyring.

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # For web dev purposes.
    3000
    5000
    8080
    # Needed for Spotify.
    57621
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.config = {
    General = {
      DiscoverableTimeout = 0;
      FastConnectable = true;
    };
    Policy = {
      AutoEnable = true;
    };
  };
  services.blueman.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,it";
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp,eurosign:e,grp:alt_space_toggle";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Enable the LightDM Display Manager.
  services.xserver.displayManager.lightdm.enable = true;
  # Enable the BSPWM Window Manager.
  services.xserver.windowManager.bspwm = {
    enable = true;
    configFile = "/home/simone/.config/bspwm/bspwmrc";
    sxhkd.configFile = "/home/simone/.config/sxhkd/sxhkdrc";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simone = {
    isNormalUser = true;
    home = "/home/simone";
    description = "Simone Ragusa";
    extraGroups = [ "wheel" "adbusers" "docker" "networkmanager" ]; # `wheel` enable ‘sudo’ for the user.
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

