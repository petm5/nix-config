{ pkgs, ... }: {

  boot.kernelParams = [ "drm.edid_firmware=eDP-1:edid/edid.bin" ];

  hardware.firmware = [ (pkgs.callPackage ./package.nix {}) ];

}
