{ config, lib, pkgs, ... }:

{

  boot.extraModprobeConfig = ''
    options i915 enable_dc=4 disable_power_well=1 enable_fbc=1 enable_psr=2
    options xe enable_dc=4 disable_power_well=1 enable_fbc=1 enable_psr=2
  '';

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime
  ];

}
