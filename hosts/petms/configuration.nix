{ config, modulesPath, ... }: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/profiles/base.nix
    ../../modules/services/upnp.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "petms";
  networking.domain = "opcc.tk";

  users.users.petms = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.openssh.enable = true;
  services.openssh.ports = [ 2273 ];

  services.upnpc.enable = true;

  time.timeZone = "America/Toronto";

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "btrfs";
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
    };
  };

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "console=ttyS0" ];

  system.stateVersion = "24.05";

}
