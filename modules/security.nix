{ config, lib, ... }:

{
  # Prevent replacing the running kernel image. A reboot is then needed.
  security.protectKernelImage = true;

  # Mount a tmpfs on `/tmp` during boot (that is, `/tmp` is mounted in ram).
  boot.tmp.useTmpfs = lib.mkDefault true;
  # If this option is disabled, then the content of `/tmp` is cleaned on boot.
  # This way `/tmp` is always volatile memory.
  boot.tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

  # Disable editing of the kernel command-line before boot.
  # See https://github.com/NixOS/nixpkgs/blob/bc06c93905f60a82d6ebbb78f78cf289257860cc/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L65.
  boot.loader.systemd-boot.editor = false;

  # Enable TCP Bottleneck Bandwidth and RTT (BBR) to improve the TCP Congestion
  # Control algorithm for better network performance.
  boot.kernelModules = [ "tcp_bbr" ];

  # Accept the CA's terms of service early.
  security.acme.acceptTerms = true;
}
