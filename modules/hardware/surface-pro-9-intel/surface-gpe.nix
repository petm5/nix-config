{ pkgs, lib, stdenv, fetchFromGitHub, kernel ? pkgs.linuxPackages_latest.kernel }:

stdenv.mkDerivation rec {
  pname = "surface-gpe";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-gpe";
    rev = "c9ffff2b9d99198c847ad383cb122eaec837d280";
    hash = "sha256-tyBqKrqKmy66DYXDt51yExiDcnI+AHBRksIEa8HfdrU=";
  };

  patches = [ ./patches/surface-gpe-sp9-fixup.patch ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  preBuild = ''
    makeFlags="$makeFlags M=$(pwd)/module"
  '';

  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux driver for Surface lid GPE";
    homepage = "https://github.com/linux-surface/surface-gpe";
    license = licenses.publicDomain;
    platforms = platforms.linux;
  };
}
