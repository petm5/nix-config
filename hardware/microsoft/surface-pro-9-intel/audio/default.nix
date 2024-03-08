{ config, lib, pkgs, ... }: {

  services.pipewire.wireplumber.configPackages = [
    (pkgs.callPackage ./package.nix {})
  ];

}
