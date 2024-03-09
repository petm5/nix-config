{ fetchFromGitHub, ... }:
let
  borePatches = fetchFromGitHub {
    owner = "firelzrd";
    repo = "bore-scheduler";
    rev = "4b10b1abef71394ca2438801cc3e31ee9bfb6943";
    sha256 = "1rqx47bhr20nzk7gfhdnfd0zhygfhswir8pxqs1k08x78sq1fjyl";
  };
in [rec {
  name = "0001-linux6.7.y-bore4.5.0";
  patch = (borePatches + "/patches/stable/linux-6.7-bore/${name}.patch");
}]
