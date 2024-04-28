{

  imports = [
    ../../modules/profiles/desktop.nix
    ../../modules/hardware/cyan
  ];

  networking.hostName = "peter-chromebook";

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
  };

  zramSwap.enable = true;

  boot.initrd.services.lvm.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    fsType = "bcachefs";
    device = "/dev/disk/by-partlabel/root"; 
  };

  fileSystems."/boot" = {
    fsType = "vfat";
    device = "/dev/disk/by-partlabel/ESP"; 
  };

  system.stateVersion = "24.05";

}
