{ config, lib, pkgs, ... }: {

  imports = [
    ../common/cpu/intel
    ../common/gpu/intel
    ./audio.nix
    ./tlp.nix
    ./kernel.nix
    ./ipts.nix
  ];

  boot.initrd.kernelModules = [ "nvme" "xhci_pci" "hid_generic" "atkbd" "surface_aggregator" "surface_aggregator_registry" "surface_aggregator_hub" "surface_hid_core" "8250_dw" "surface_hid" "intel_lpss" "intel_lpss_pci" "pinctrl_tigerlake" "usbhid" ];

  boot.swraid.enable = false;

  boot.initrd.includeDefaultModules = false;

  boot.initrd.availableKernelModules = [ "thunderbolt" "usb_storage" "sd_mod" ];

  boot.kernelParams = [ "mem_sleep_default=deep" "drm.edid_firmware=eDP-1:edid/surface-pro-9-display.bin" ];

  hardware.firmware = [ (pkgs.runCommandNoCC "firmware-custom-edid" {} ''
      mkdir -p $out/lib/firmware/edid/
      cp "${./edid.bin}" $out/lib/firmware/edid/surface-pro-9-display.bin
    ''
  ) ];

}
