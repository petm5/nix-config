{ lib, stdenv, kernel, writeText }: let

moduleTargets = [
  "drivers/platform/surface/surface_platform_profile"
];

modulesOrder = writeText "modules.order" (
  lib.concatLines (
    map (t: t + ".o") moduleTargets));

in stdenv.mkDerivation {
  pname = "surface-platform-profile";

  inherit (kernel) src version postPatch nativeBuildInputs;

  patches = [
    ./0001-platform-surface-platform_profile-add-fan-power-stat.patch
  ];

  makeFlags = kernel.commonMakeFlags ++ [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MO=$(buildRoot)"
    "M=$(modulesSrc)"
  ];

  buildFlags = map (t: t + ".ko") moduleTargets;

  configurePhase = ''
    runHook preConfigure

    export buildRoot="$(pwd)/build"
    export modulesSrc="$(pwd)"

    runHook postConfigure
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  preInstall = ''
    ln -s ${modulesOrder} $buildRoot/modules.order
  '';
}
