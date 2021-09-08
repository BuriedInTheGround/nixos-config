{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.amd;
in {
  options.modules.hardware.amd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
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

    # Set the video driver to use radeon.
    services.xserver.videoDrivers = [ "radeon" ]; # Set to "amdgpu" if needed.

    # Add the user to the `video` group.
    user.extraGroups = [ "video" ];
  };
}
