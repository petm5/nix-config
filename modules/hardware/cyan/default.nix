{ config, lib, pkgs, ... }: {

  imports = [
    ../common/cpu/intel
    ../common/gpu/intel
  ];

  boot.initrd.kernelModules = [ "atkbd" "sd_mod" "sdhci" "sdhci_pci" ];

}
