{

  boot.kernelModules = [ "kvm-intel" ];

  fileSystems = {
    "/" = {
      fsType = "btrfs";
      options = [ "subvol=@" "noatime" "compress=zstd" ];
      device = "/dev/mapper/root";
      encrypted = {
        enable = true;
        label = "root";
        blkDev = "/dev/vg0/nixos";
      };
    };
    "/boot" = {
      label = "SYSTEM";
      fsType = "vfat";
    };
    "/home" = {
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
      device = "/dev/mapper/root";
    };
    "/nix" = {
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress=zstd" ];
      device = "/dev/mapper/root";
    };
  };

  boot.initrd.luks.devices."root".allowDiscards = true;

  boot.initrd.luks.cryptoModules = [ "aes" "aes_generic" "cbc" "sha1" "sha256" "sha512" "af_alg" ];

}
