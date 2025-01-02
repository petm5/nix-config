{ config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/surface-pro-9-intel
    ../../modules/profiles/desktop.nix
    ../../modules/profiles/wifi.nix
    ../../modules/profiles/secure-boot.nix
    ../../modules/profiles/touchscreen
  ];

  networking.hostName = "peter-pc";

  users.users.petms = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "video" "scanner" "lp" "wireshark" "storage" ];
    linger = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "petms";
  };

  time.timeZone = "America/Toronto";

  console.keyMap = "us";

  zramSwap.enable = true;

  boot.initrd.services.lvm.enable = true;

  virtualisation.podman.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.wireshark.enable = true;

  programs.sway.enable = true;
  programs.sway.package = pkgs.swayfx;

  networking.hosts = {
    "2600:1f11:2d6:1400:92eb:9519:5eb5:f86b" = [ "logotherapy.ca.staging.cool" ];
  };

  swapDevices = [{
    device = "/swap";
  }];

  system.stateVersion = "24.05";

}
