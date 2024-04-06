{ config, lib, pkgs, ... }: let
  linuxSurface = pkgs.fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "daac927ae7cb7b87c81b22bb32789e1065e118e3";
    hash = "sha256-IuQ34p/6cn25DU1sDpJAIwKu5avuFOStnzqZeMlx+Yo=";
  };
in {

  imports = [
    ../common/cpu/intel
    ../common/gpu/intel
    ./audio.nix
    ./tlp.nix
    ../../ipu6-softisp/config.nix
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

  boot.kernelPackages = pkgs.linuxPackagesFor
    (pkgs.linux_latest.override {
      kernelPatches = map (pname: {
        name = "linux-surface-${pname}";
        patch = (linuxSurface + "/patches/6.8/${pname}.patch");
      }) [
        "0001-surface3-oemb"
        "0002-mwifiex"
        "0003-ath10k"
        "0004-ipts"
        "0005-ithc"
        "0006-surface-sam"
        "0007-surface-sam-over-hid"
        "0008-surface-button"
        "0009-surface-typecover"
        "0010-surface-shutdown"
        "0011-surface-gpe"
        "0013-amd-gpio"
        "0014-rtc"
      ];
      autoModules = false;
      ignoreConfigErrors = false;
      extraStructuredConfig = with lib.kernel; {
        SURFACE_AGGREGATOR = module;
        SURFACE_AGGREGATOR_BUS = yes;
        SURFACE_AGGREGATOR_CDEV = module;
        SURFACE_AGGREGATOR_HUB = module;
        SURFACE_AGGREGATOR_REGISTRY = module;
        SURFACE_AGGREGATOR_TABLET_SWITCH = module;

        SURFACE_ACPI_NOTIFY = module;
        SURFACE_DTX = module;
        SURFACE_PLATFORM_PROFILE = module;

        SURFACE_HID = module;
        SURFACE_KBD = module;

        BATTERY_SURFACE = module;
        CHARGER_SURFACE = module;

        SENSORS_SURFACE_TEMP = module;
        SENSORS_SURFACE_FAN = module;

        SURFACE_HOTPLUG = module;

        HID_IPTS = module;
        HID_ITHC = module;

        IPU_BRIDGE = module;

        VIDEO_OV5693 = module;
        VIDEO_OV7251 = module;
        VIDEO_OV8865 = module;

        APDS9960 = module;

        INPUT_SOC_BUTTON_ARRAY = module;
        SURFACE_3_POWER_OPREGION = module;
        SURFACE_PRO3_BUTTON = module;
        SURFACE_GPE = module;
        SURFACE_BOOK1_DGPU_SWITCH = module;
      };
    });

}
