{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "surface-gpe";
  version = "0.1";

  src = ./surface-gpe;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  postPatch = ''
    sed -i ./Makefile -e '/depmod/d'
  '';

  installPhase = ''
    install -D surface_gpe.ko $out/lib/modules/${kernel.modDirVersion}/misc/surface_gpe.ko
  '';

  meta = with lib; {
    description = "Linux driver for Surface lid GPE";
    homepage = "https://github.com/linux-surface/surface-gpe";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.9";
  };
}
