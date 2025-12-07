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
    rev = "f2398486780962e8262e97099f0f808210834d60";
    hash = "sha256-KqUOEpoLjnchI/z8JcklJ4iLk9Nus3Ty7Jyywe9ta08=";
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
