{ config, lib, pkgs, ... }: {

  imports = [
    ../../modules/profiles/desktop.nix
    ./hardware-configuration.nix
    ../../modules/hardware/surface-pro-9-intel
    ../../modules/profiles/secure-boot.nix
  ];

  networking.hostName = "peter-pc";

  users.users.petms = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "scanner" "lp" ];
  };

  time.timeZone = "America/Toronto";

  console.keyMap = "us";

  networking.wireless.iwd.settings = {
    General = {
      Country = "CA";
      # Prevent tracking across networks
      AddressRandomization = "network";
    };
    Rank = {
      # Prefer faster bands
      BandModifier2_4GHz = 1.0;
      BandModifier5GHz = 3.0;
      BandModifier6GHz = 10.0;
    };
  };

  zramSwap.enable = true;

  security.tpm2.enable = true;

  boot.initrd.services.lvm.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";

}
