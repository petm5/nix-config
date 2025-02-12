{ lib, stdenv, fetchFromGitHub, kernel, kernelModuleMakeFlags }:

stdenv.mkDerivation rec {
  pname = "surface-gpe";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "petm5";
    repo = "surface-gpe";
    rev = "c3ab21c6d7b6497c4474ddf707b3fa6729f587c6";
    hash = "sha256-3jaYoXNfvJeDt9yTPkKIqJgisYYEUJrfLYuvfmNAOFY=";
  };

  sourceRoot = "${src.name}/module";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    strip -S surface_gpe.ko
    xz surface_gpe.ko
    install -D surface_gpe.ko.xz -t $out/lib/modules/${kernel.modDirVersion}/updates
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux driver for Surface lid GPE";
    homepage = "https://github.com/linux-surface/surface-gpe";
    license = licenses.publicDomain;
    platforms = platforms.linux;
  };
}
