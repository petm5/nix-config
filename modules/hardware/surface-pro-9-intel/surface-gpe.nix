{ pkgs, lib, stdenv, fetchFromGitHub, kernel ? pkgs.linuxPackages_latest.kernel }:

stdenv.mkDerivation rec {
  pname = "surface-gpe";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "petm5";
    repo = "surface-gpe";
    rev = "c3ab21c6d7b6497c4474ddf707b3fa6729f587c6";
    hash = "sha256-3jaYoXNfvJeDt9yTPkKIqJgisYYEUJrfLYuvfmNAOFY=";
  };

  patches = [ ];

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
