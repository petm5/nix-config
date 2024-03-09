{ fetchFromGitHub, ... }:
let
  linuxSurface = fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "3c1b47315d1e4f49b13903f07618310c65b16e64";
    sha256 = "08zhvy76171zv35wwvwijcqpvxbn9vzlcprslsp33gbvc7gkff9j";
  };
in map (pname: {
  name = "linux-surface-${pname}";
  patch = (linuxSurface + "/patches/6.7/${pname}.patch");
}) [
  "0004-ipts"
  "0005-ithc"
  "0006-surface-sam"
  "0009-surface-typecover"
  "0010-surface-shutdown"
  "0011-surface-gpe"
  "0014-rtc"
]
