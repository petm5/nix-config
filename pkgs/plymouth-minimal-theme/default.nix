{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  name = "plymouth-minimal-theme";

  src = ./minimal;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/minimal
    cp * $out/share/plymouth/themes/minimal
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';
}
