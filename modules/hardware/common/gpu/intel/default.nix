{ config, lib, pkgs, ... }:

{
  # boot.initrd.kernelModules = [ "i915" ];

  # boot.kernelParams = [
  #   "i915.enable_psr=2"
  #   "i915.enable_psr2_sel_fetch=1"
  #   "i915.enable_fbc=1"
  # ];

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime
  ];
}
