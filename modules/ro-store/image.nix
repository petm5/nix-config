{ config, lib, pkgs, modulesPath, utils, ... }:
let

  cfg = config.ab-image;

  efiArch = pkgs.stdenv.hostPlatform.efiArch;

in

{

  imports = [(modulesPath + "/image/repart.nix")];

  system.build.erofs = pkgs.callPackage ./erofs.nix {
    storeContents = [ config.system.build.toplevel ];
    label = cfg.version;
  };

  image.repart.partitions = {
    "10-esp" = {
      contents = lib.mkMerge [
        {
          "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
            "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

          "/EFI/Linux/${cfg.version}.efi".source =
            "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
        }
      ];
      repartConfig = {
        Type = "esp";
        Format = "vfat";
        SizeMinBytes = "96M";
        Label = "esp";
      };
    };
    "20-usr" = {
      repartConfig = {
        Type = "usr";
        SizeMaxBytes = "512M";
        Label = cfg.version;
        CopyBlocks = "${config.system.build.erofs}";
      };
      stripNixStorePrefix = true;
    };
  };

  boot.initrd.systemd.additionalUpstreamUnits = [ "initrd-usr-fs.target" ];

  fileSystems = lib.mkOverride 50 {
    "/" = {
      fsType = "btrfs";
      device = "/dev/mapper/state";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-partlabel/state";
        label = "state";
      };
    };
    "/usr" = {
      fsType = "erofs";
      label = cfg.version;
    };
    "/nix/store" = {
      fsType = "none";
      device = "/usr";
      options = [ "bind" ];
      neededForBoot = true;
    };
    "/efi" = {
      fsType = "vfat";
      device = "/dev/disk/by-partlabel/esp";
      neededForBoot = true;
    };
  };

}
