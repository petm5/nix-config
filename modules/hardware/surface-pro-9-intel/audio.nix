{ pkgs, ... }:

let

  surface-audio = pkgs.callPackage ../../../pkgs/surface-audio {};

in {

  services.pipewire.wireplumber.configPackages = [ surface-audio ];

}
