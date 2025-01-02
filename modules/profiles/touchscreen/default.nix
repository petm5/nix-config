{

  nixpkgs.overlays = [ (final: prev: {
    buffybox = prev.buffybox.overrideAttrs (prevAttrs: finalAttrs: rec {
      patchPhase = ''
        cp ${./font_32.c} buffyboard/font_32.c
      '';
    });
  }) ];

  boot.initrd.unl0kr = {
    enable = true;
    settings = {
      general = {
        backend = "drm";
        animations = false;
      };
      theme = {
        default = "pmos-dark";
        alternate = "pmos-light";
      };
      keyboard = {
        autohide = false;
        layout = "us";
        popovers = false;
      };
      input = {
        pointer = false;
      };
    };
  };

}
