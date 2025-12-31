{ lib, stdenv, kernel, writeText }: let

moduleTargets = [
  "drivers/platform/x86/intel/int3472/intel_skl_int3472_common"
  "drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete"
  "drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470"
  "drivers/media/pci/intel/ipu-bridge"
  "drivers/media/i2c/ov5693"
  "drivers/media/i2c/ov13858"
  "drivers/media/i2c/dw9719"
];

modulesOrder = writeText "modules.order" (
  lib.concatLines (
    map (t: t + ".o") moduleTargets));

in stdenv.mkDerivation {
  pname = "surface-ipu6-camera-modules";
  version = "0.1";

  src = kernel.src;

  patches = [
    ./surface-cameras.patch
  ];

  makeFlags = [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MO=$(buildRoot)"
    "M=$(modulesSrc)"
  ];

  buildFlags = map (t: t + ".ko") moduleTargets;

  nativeBuildInputs = kernel.nativeBuildInputs;

  configurePhase = ''
    runHook preConfigure

    mkdir build
    export buildRoot="$(pwd)/build"

    export modulesSrc="$(pwd)"

    runHook postConfigure

    cd $buildRoot
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  preInstall = ''
    ln -s ${modulesOrder} $buildRoot/modules.order
  '';

  meta = {
    description = "Patched Linux drivers for Microsoft Surface IPU6 cameras";
    inherit (kernel.meta) license platforms;
  };
}
