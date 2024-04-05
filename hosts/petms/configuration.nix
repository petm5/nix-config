{ config, modulesPath, ... }: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "petms";
  networking.domain = "opcc.tk";

  virtualisation.vmVariant.config = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      diskSize = 102400;
    };

    networking.interfaces.eth0.macAddress = "0e:a8:8e:d5:10:f0";
  };

  services.openssh.enable = true;
  services.openssh.ports = [ 2273 ];

  time.timeZone = "America/Toronto";

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/efi" = {
      label = "ESP";
      fsType = "vfat";
    };
  };

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";

}
