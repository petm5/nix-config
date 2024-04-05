{ config, modulesPath, ... }: {

  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot.initrd.systemd.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
