{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    # Set monitors.
    "video=DP-1:1920x1080@60"
    "video=HDMI-A-1:1920x1080@60"
  ];

  # Update Intel CPU microcode.
  hardware.cpu.intel.updateMicrocode = true;

  # Enable Vulkan (Mesa).
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.opengl.extraPackages = with pkgs; [
    # Enable OpenCL.
    rocm-opencl-icd
    rocm-opencl-runtime

    # Enable amdvlk drivers for Vulkan.
    amdvlk
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    # Enable amdvlk drivers (32 bit) for Vulkan.
    driversi686Linux.amdvlk
  ];


  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

}
