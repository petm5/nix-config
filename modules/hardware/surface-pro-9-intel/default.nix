{ config, lib, pkgs, ... }: {

  imports = [
    ../common/cpu/intel
    ../common/gpu/intel
    ./audio.nix
    ./tlp.nix
  ];

  boot.extraModulePackages = [
    (pkgs.callPackage ../../../pkgs/ithc-linux/latest.nix { inherit (config.boot.kernelPackages) kernel kernelModuleMakeFlags; })
  ];

  systemd.services.surface-gpe = {
    script = ''
      ${pkgs.kmod}/bin/insmod ${(config.boot.kernelPackages.callPackage ../../../pkgs/surface-gpe {})}/lib/modules/*/updates/surface_gpe.ko*
    '';
    wantedBy = [ "default.target" ];
    restartIfChanged = false;
    serviceConfig.RemainAfterExit = true;
  };

  boot.initrd.kernelModules = [ "nvme" "xhci_pci" "hid_generic" "atkbd" "surface_aggregator" "surface_aggregator_registry" "surface_aggregator_hub" "surface_hid_core" "8250_dw" "surface_hid" "intel_lpss" "intel_lpss_pci" "pinctrl_tigerlake" "usbhid" "ithc" ];

  boot.swraid.enable = false;

  boot.initrd.includeDefaultModules = false;

  boot.initrd.availableKernelModules = [ "thunderbolt" "usb_storage" "sd_mod" ];

  boot.kernelParams = [ "pcie_aspm=force" "workqueue.power_efficient=true" "pci=hpiosize=0" ];

  boot.extraModprobeConfig = ''
    options iwlwifi power_level=5 uapsd_disable=0 power_save=Y
    options iwlmvm power_scheme=3
  '';

  services.iptsd.enable = lib.mkDefault true;
  services.iptsd.config = import ./iptsd-config.nix;

  services.thermald = lib.mkDefault {
    enable = true;
    configFile = ./thermal-conf.xml;
  };

}
