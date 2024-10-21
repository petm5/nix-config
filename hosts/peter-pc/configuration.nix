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
    extraGroups = [ "users" "wheel" "video" "scanner" "lp" "wireshark" ];
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

  system.stateVersion = "24.05";

}
