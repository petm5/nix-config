{ modulesPath, ... }: {

  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot.initrd.systemd.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

}
