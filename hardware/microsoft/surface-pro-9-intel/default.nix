{ config, lib, pkgs, ... }:
{

  imports = [
    ../../common/cpu/intel
    ../../common/gpu/intel
    ./kernel
    ./edid
    ./ipts
    ./audio
  ];

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  boot.initrd.kernelModules = [ "nvme" "xhci_pci" "hid_generic" "atkbd" "surface_aggregator" "surface_aggregator_registry" "surface_aggregator_hub" "surface_hid_core" "8250_dw" "surface_hid" "intel_lpss" "intel_lpss_pci" "pinctrl_tigerlake" "usbhid" ];

  boot.kernelModules = [ "kvm-intel" ];

  boot.swraid.enable = false;

  boot.initrd.includeDefaultModules = false;

  boot.initrd.availableKernelModules = [ "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.luks.cryptoModules = [ "aes" "aes_generic" "cbc" "sha1" "sha256" "sha512" "af_alg" ];

}
