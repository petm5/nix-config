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
    rev = "bb17135bc2a3c6b0e2886d3d3f42be9d32fd49f8";
    hash = "sha256-P2L7OV6xfs8KdrXZWMgMfETQocjGGS3qC1/Wk8uk3yA=";
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
