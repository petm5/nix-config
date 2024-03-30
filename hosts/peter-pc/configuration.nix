{ config, lib, pkgs, ... }: {

  imports = [
    ../../profiles/desktop.nix
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

  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      encrypted = {
        enable = true;
        label = "root";
        blkDev = "/dev/vg0/lv0";
      };
    };
    "/boot" = {
      label = "SYSTEM";
      fsType = "vfat";
    };
  };

  boot.initrd.services.lvm.enable = true;

  system.stateVersion = "24.05";

}
