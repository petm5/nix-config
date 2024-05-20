{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "i915" ];

  boot.kernelParams = [
    "i915.enable_psr=2"
    "i915.enable_psr2_sel_fetch=1"
    "i915.enable_fbc=1"
  ];

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
  ];
}
