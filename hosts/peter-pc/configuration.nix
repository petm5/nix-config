{ config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/surface-pro-9-intel
    ../../modules/profiles/desktop.nix
    ../../modules/profiles/wifi.nix
    ../../modules/profiles/secure-boot.nix
  ];

  networking.hostName = "peter-pc";

  users.users.petms = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "video" "scanner" "lp" "storage" ];
    linger = true;
    initialPassword = "test";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.petms = import ../../homes/petms/peter-pc.nix;

  services.displayManager.autoLogin = {
    enable = true;
    user = "petms";
  };

  services.getty.autologinUser = "petms";
  services.getty.autologinOnce = true;

  time.timeZone = "America/Toronto";

  console.keyMap = "us";

  zramSwap.enable = true;

  boot.initrd.services.lvm.enable = true;

  services.fwupd.enable = true;

  system.stateVersion = "24.05";

  # TODO: Remove when camera patches are stable
  boot.blacklistedKernelModules = [ "ov5693" "ov13858" "intel_ipu6_isys" "intel_ipu6" "ipu_bridge" "intel_skl_int3472_discrete" "intel_skl_int3472_tps68470" ];

}
