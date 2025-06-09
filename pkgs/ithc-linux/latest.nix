{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "ithc";
  version = "unstable-6d53c9c";

  src = fetchFromGitHub {
    owner = "quo";
    repo = "ithc-linux";
    rev = "6d53c9c21797df5da975bd27db22bd89ee0cead3";
    hash = "sha256-uO+tsCn6LZlAXq1jvqwpFuLluzlWr/auJy9R6Uiv0PE=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  postPatch = ''
    sed -i ./Makefile -e '/depmod/d'
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  meta = with lib; {
    description = "Linux driver for Intel Touch Host Controller";
    homepage = "https://github.com/quo/ithc-linux";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    broken = kernel.kernelOlder "6.10";
  };
}
