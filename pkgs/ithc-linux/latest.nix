{ kernelPackages, fetchFromGitHub, ... }:
kernelPackages.ithc.overrideAttrs {
  src = fetchFromGitHub {
    owner = "quo";
    repo = "ithc-linux";
    rev = "8b22c724e7ef837e3e122a38f60aa85112af65db";
    hash = "sha256-gUmbL4Q4DP4HO/Dux1KKFRA74JG3P34t2WHkFsSenAA=";
  };
}
