{ pkgs, ... }: let
  package = pkgs.callPackage ./package.nix {};
in {

  boot.kernelParams = [ "drm.edid_firmware=eDP-1:edid/edid.bin" ];

  hardware.firmware = [ package ];

}
