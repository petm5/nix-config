{ lib, pkgs, ... }: {

  boot.initrd.systemd.enable = true;

  systemd.network.enable = lib.mkDefault true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  services.resolved.settings.Resolve = {
    DNSOverTLS = true;
    DNSSEC = true;
    Domains = "~.";
  };

  # We don't need to support legacy BIOS systems by default
  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Fix BitLocker recovery on bootloder update
  boot.loader.systemd-boot.rebootForBitlocker = true;

  security.tpm2.enable = true;

  hardware.block.defaultScheduler = "kyber";
  hardware.block.defaultSchedulerRotational = "bfq";

  services.journald.settings.Journal = {
    Storage = "volatile";
    RuntimeMaxUse = "32M";
  };

  # Use the latest available kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
