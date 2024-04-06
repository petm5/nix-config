{

  boot.kernelParams = [ "drm.edid_firmware=DP-2:edid/monitor-edid.bin" ];

  hardware.firmware = [ (pkgs.runCommandNoCC "firmware-custom-edid" {} ''
      mkdir -p $out/lib/firmware/edid/
      cp "${./monitor-edid-mod.bin}" $out/lib/firmware/edid/monitor-edid.bin
    ''
  ) ];

}
