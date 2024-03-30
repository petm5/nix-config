{ config, modulesPath, ... }: {

  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot.initrd.systemd.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/home" = {
      inherit (config.fileSystems."/") device label;
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };
    "/nix" = {
      inherit (config.fileSystems."/") device label;
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
