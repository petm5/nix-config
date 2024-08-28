{ config, modulesPath, ... }: {

  boot.initrd.systemd.enable = true;

  documentation.enable = false;

  networking.useNetworkd = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
