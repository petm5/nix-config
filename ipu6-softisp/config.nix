{ pkgs, lib, ... }:

let
  libcamera = pkgs.libcamera.overrideAttrs (old: {
    mesonFlags = old.mesonFlags or [ ] ++ [
      "-Dpipelines=simple,ipu3,uvcvideo"
      "-Dipas=simple,ipu3"
    ];

    # This is
    # https://copr-dist-git.fedorainfracloud.org/cgit/jwrdegoede/ipu6-softisp/libcamera.git/plain/libcamera-0.2.0-softisp.patch?h=f39&id=60e6b3d5e366a360a75942073dc0d642e4900982,
    # but manually piped to git and back, as some renames were not processed properly.
    # It was later refreshed with https://patchwork.libcamera.org/cover/19663/
    patches = old.patches or [ ] ++ [
      ./libcamera/0001-libcamera-pipeline-simple-fix-size-adjustment-in-val.patch
      ./libcamera/0002-libcamera-internal-Move-dma_heaps.-h-cpp-to-common-d.patch
      ./libcamera/0003-libcamera-dma_heaps-extend-DmaHeap-class-to-support-.patch
      ./libcamera/0004-libcamera-internal-Move-SharedMemObject-class-to-a-c.patch
      ./libcamera/0005-libcamera-shared_mem_object-reorganize-the-code-and-.patch
      ./libcamera/0006-libcamera-software_isp-Add-SwStatsCpu-class.patch
      ./libcamera/0007-libcamera-software_isp-Add-Debayer-base-class.patch
      ./libcamera/0008-libcamera-software_isp-Add-DebayerCpu-class.patch
      ./libcamera/0009-libcamera-ipa-add-Soft-IPA.patch
      ./libcamera/0010-libcamera-introduce-SoftwareIsp.patch
      ./libcamera/0011-libcamera-pipeline-simple-rename-converterBuffers_-a.patch
      ./libcamera/0012-libcamera-pipeline-simple-enable-use-of-Soft-ISP-and.patch
      ./libcamera/0013-libcamera-swstats_cpu-Add-support-for-8-10-and-12-bp.patch
      ./libcamera/0014-libcamera-debayer_cpu-Add-support-for-8-10-and-12-bp.patch
      ./libcamera/0015-libcamera-debayer_cpu-Add-BGR888-output-support.patch
      ./libcamera/0016-libcamera-Add-support-for-IGIG_GBGR_IGIG_GRGB-bayer-.patch
      ./libcamera/0017-libcamera-Add-Software-ISP-benchmarking-documentatio.patch
      ./libcamera/0018-libcamera-software_isp-Apply-black-level-compensatio.patch
      ./libcamera/0019-libcamera-Soft-IPA-use-CameraSensorHelper-for-analog.patch
      ./libcamera/0020-ov01a1s-HACK.patch
      ./libcamera/0021-libcamera-debayer_cpu-Make-the-minimum-size-1280x720.patch
    ];
  });

  # use patched libcamera
  pipewire' = (pkgs.pipewire.override {
    inherit libcamera;
  });

  wireplumber' = (pkgs.wireplumber.override {
    pipewire = pipewire';
  });
in
{
  boot.kernelPatches = [{
    name = "linux-kernel-test.patch";
    patch = ./kernel/softisp.patch;
    extraStructuredConfig = {
      # needed for /dev/dma_heap
      DMABUF_HEAPS_CMA = lib.kernel.yes;
      DMABUF_HEAPS_SYSTEM = lib.kernel.yes;
      DMABUF_HEAPS = lib.kernel.yes;
    };
  }];


  services.udev.extraRules = ''
    KERNEL=="system", SUBSYSTEM=="dma_heap", TAG+="uaccess"
  '';

  # provide qcam in $PATH.
  environment.systemPackages = [
    (libcamera.override {
      withQcam = true;
    })
  ];

  services.pipewire.package = pipewire';
  services.pipewire.wireplumber.package = wireplumber';
}
