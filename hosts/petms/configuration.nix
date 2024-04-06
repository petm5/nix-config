{ config, modulesPath, ... }: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
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

  time.timeZone = "America/Toronto";

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "btrfs";
    };
    "/efi" = {
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
