{ config, lib, pkgs, ... }: {

  imports = [
    ../../modules/profiles/desktop.nix
    ../../modules/hardware/wifi.nix
    ./hardware-configuration.nix
    ../../modules/hardware/surface-pro-9-intel
    ../../modules/profiles/secure-boot.nix
    ../../modules/overlays/wayland-edge.nix
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

  # services.restic.backups.remote = {
  #   repository = "sftp://petms@opcc.opcc.tk:2272/backups/peter-pc";
  #   passwordFile = "/etc/nixos/restic-password";
  #   paths = [
  #     "/home"
  #   ];
  #   exclude = [
  #     "/home/*/.cache"
  #     "/home/*/Downloads"
  #   ];
  #   timerConfig = {
  #     OnCalendar = "00:05";
  #     RandomizedDelaySec = "5h";
  #   };
  # };

  time.timeZone = "America/Toronto";

  console.keyMap = "us";

  zramSwap.enable = true;

  security.tpm2.enable = true;

  boot.initrd.services.lvm.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.rebootForBitlocker = true;

  # networking.wireguard.interfaces."wg0" = {
  #   privateKeyFile = "/root/wg-key";
  #   ips = [ "10.100.0.3/32" ];
  #   peers = [{
  #     endpoint = "opcc.opcc.tk:25565";
  #     allowedIPs = [ "10.100.0.1/32" ];
  #     publicKey = "xPAmZH9tIelqwpX4S1sUpK4Domngce/UA7kr3u/fAlo=";
  #   }];
  # };

  virtualisation.podman.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.fwupd.enable = true;

  programs.wireshark.enable = true;

  system.stateVersion = "24.05";

}
