{
  stdenvNoCC,
  nix-update-script,
  fetchFromGitHub,
  bankstown-lv2,
  lsp-plugins,
}:

stdenvNoCC.mkDerivation {
  pname = "surface-audio";
  version = "git";

  src = fetchFromGitHub {
    owner = "petm5";
    repo = "surface-audio";
    rev = "e8a7fcf97796c84f90756ec232cd074a2b8a7f5f";
    sha256 = "1yb9nvz8whjk1a88mvzk5b3jwakbp0241c3yfvhj6zzrajqbgpcx";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "DATA_DIR=share"
  ];

  fixupPhase = ''
    runHook preFixup

    for config_file in $(find $out -type f -not -name '*.wav') ; do
        substituteInPlace "$config_file" --replace-warn "/usr" "$out"
    done

    runHook postFixup
  '';

  passthru = {
    updateScript = nix-update-script { };
    requiredLv2Packages = [ bankstown-lv2 lsp-plugins ];
  };
}
