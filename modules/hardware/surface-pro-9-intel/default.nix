{ config, lib, pkgs, ... }: {

  imports = [
    ../common/cpu/intel
    ../common/gpu/intel
    ./audio.nix
    ./tlp.nix
    # ./kernel.nix
    ./ipts.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModulePackages = [
    (config.boot.kernelPackages.ithc.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "quo";
        repo = "ithc-linux";
        rev = "2cdcb7824e17a950a561f5becdc122c9c917744f";
        hash = "sha256-5RSbrLB57WuDrya+icJ2cO3xvrwlWZWxQLTa2Iaa8Kg=";
      };
    })
    (pkgs.callPackage ./gpe.nix { inherit (config.boot.kernelPackages) kernel; })
  ];

  boot.initrd.kernelModules = [ "nvme" "xhci_pci" "hid_generic" "atkbd" "surface_aggregator" "surface_aggregator_registry" "surface_aggregator_hub" "surface_hid_core" "8250_dw" "surface_hid" "intel_lpss" "intel_lpss_pci" "pinctrl_tigerlake" "usbhid" ];

  boot.swraid.enable = false;

  boot.initrd.includeDefaultModules = false;

  boot.initrd.availableKernelModules = [ "thunderbolt" "usb_storage" "sd_mod" ];

  # boot.kernelParams = [ "drm.edid_firmware=eDP-1:edid/surface-pro-9-display.bin" ];
  boot.kernelParams = [ "pcie_aspm=force" "workqueue.power_efficient=true" "intremap=nosid" ];

  # boot.initrd.prepend = [
  #   "${(pkgs.runCommand "build-dsdt-override" {
  #     nativeBuildInputs = [ pkgs.cpio ];
  #   } ''
  #     mkdir -p "$out/tmp"
  #     mkdir -p "$out/tmp/kernel/firmware/acpi"
  #     cp ${./dsdt.aml} "$out/tmp/kernel/firmware/acpi/dsdt.aml"
  #     cd "$out/tmp"
  #     find kernel | cpio -H newc --create > "$out/acpi_override"
  #     rm -rf "$out/tmp"
  #   '')}/acpi_override"
  # ];

  # hardware.firmware = [ (pkgs.runCommandNoCC "firmware-custom-edid" {} ''
  #     mkdir -p $out/lib/firmware/edid/
  #     cp "${./edid.bin}" $out/lib/firmware/edid/surface-pro-9-display.bin
  #   ''
  # ) ];

}
