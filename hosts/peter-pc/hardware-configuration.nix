{

  boot.kernelModules = [ "kvm-intel" ];

  fileSystems = {
    "/" = {
      fsType = "btrfs";
      options = [ "subvol=@" ];
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
    "/home" = {
      fsType = "btrfs";
      options = [ "subvol=@home" ];
      device = "/dev/mapper/root";
    };
    "/nix" = {
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
      device = "/dev/mapper/root";
    };
  };

  boot.initrd.luks.devices."root".allowDiscards = true;

  boot.initrd.luks.cryptoModules = [ "aes" "aes_generic" "cbc" "sha1" "sha256" "sha512" "af_alg" ];

}
