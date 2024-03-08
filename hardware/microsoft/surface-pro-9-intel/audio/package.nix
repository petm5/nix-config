{ lib
, stdenv
, fetchFromGitHub
, device ? "sp9"
, ... }:

stdenv.mkDerivation {
  pname = "surface-pro-9-audio";
  version = "0.1";

  nativeBuildInputs = [];

  src = fetchFromGitHub {
    owner = "peter-marshall5";
    repo = "surface-audio";
    rev = "main";
    hash = "sha256-flIW2hkvRwRArVXeLFm8mxjCaiUFBOJSEddQFVW5otM";
  };

  installPhase = ''
    mkdir -p $out/share/wireplumber/policy.lua.d
    install 85-surface-policy.lua $out/share/wireplumber/policy.lua.d
    mkdir -p $out/share/surface-audio
    install devices/${device}/graph.json $out/share/surface-audio
    install devices/${device}/impulse.wav $out/share/surface-audio
  '';
}
