{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  pname = "surface-pro-9-edid";
  version = "0.1";

  nativeBuildInputs = [];

  src = fetchFromGitHub {
    owner = "peter-marshall5";
    repo = "surface-edid";
    rev = "main";
    hash = "sha256-JPBO0WzsM0CZ33yYTLkKJym/ZMHmce9TKurf7kLnc1w=";
  };

  installPhase = ''
    install -Dm644 ./edid-sp9-minimum-60hz.bin ${placeholder "out"}/lib/firmware/edid/edid.bin
  '';
}
