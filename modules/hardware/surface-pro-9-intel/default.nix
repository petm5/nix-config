{ config, lib, pkgs, ... }: {

  imports = [
    ../common/cpu/intel
    ../common/gpu/intel
    ./audio.nix
    ./tlp.nix
    ./ipts.nix
  ];

  boot.extraModulePackages = [
    (config.boot.kernelPackages.ithc.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "quo";
        repo = "ithc-linux";
        rev = "8b22c724e7ef837e3e122a38f60aa85112af65db";
        hash = "sha256-gUmbL4Q4DP4HO/Dux1KKFRA74JG3P34t2WHkFsSenAA=";
      };
    })
  ];

  systemd.services.surface-gpe = {
    script = ''
      ${pkgs.kmod}/bin/insmod ${(config.boot.kernelPackages.callPackage ./surface-gpe.nix {})}/lib/modules/*/updates/surface_gpe.ko*
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
    options iwlwifi power_level=5 power_save=Y
    options iwlmvm power_scheme=3
  '';

}
