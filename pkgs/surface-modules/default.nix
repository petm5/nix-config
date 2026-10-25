{ lib, stdenv, kernel, kernelModuleMakeFlags, writeText }: let

  moduleTargets = [
    "drivers/platform/x86/intel/int3472/intel_skl_int3472_common"
    "drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete"
    "drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470"
    "drivers/media/pci/intel/ipu-bridge"
    "drivers/media/pci/intel/ipu6/intel-ipu6"
    "drivers/media/pci/intel/ipu6/intel-ipu6-isys"
    "drivers/media/i2c/ov5693"
    "drivers/media/i2c/ov13858"
    "drivers/media/i2c/dw9719"
    "drivers/media/i2c/vd55g0"
    "drivers/power/supply/surface_battery"
    "drivers/platform/surface/surface_platform_profile"
  ];

  modulesOrder = writeText "modules.order" (
    lib.concatLines (
      map (t: t + ".o") moduleTargets));

in stdenv.mkDerivation {
  pname = "surface-modules";

  inherit (kernel) src version;
  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = lib.fileset.toList
    (lib.fileset.fileFilter (file: file.hasExt "patch") ./patches);

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
    "-C" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "CONFIG_VIDEO_VD55G0=m"
  ];

  buildFlags = map (t: t + ".ko") moduleTargets;

  configurePhase = ''
    runHook preConfigure

    export buildRoot="$NIX_BUILD_TOP/build"
    mkdir -- "$buildRoot"

    export KBUILD_EXTMOD="$PWD"
    export KBUILD_EXTMOD_OUTPUT="$buildRoot"

    runHook postConfigure
  '';

  installTargets = [ "modules_install" ];

  preInstall = ''
    ln -s ${modulesOrder} $buildRoot/modules.order
  '';

  meta = {
    description = "Custom downstream modules for Microsoft Surface devices";
    inherit (kernel.meta) license platforms;
    broken = lib.versionOlder kernel.version "7.3";
  };
}
