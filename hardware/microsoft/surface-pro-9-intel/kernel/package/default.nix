{ lib
, callPackage
, baseKernel
, fetchFromGitHub
, linuxManualConfig
, ... }:

linuxManualConfig {
  inherit (baseKernel) src modDirVersion;
  version = "${baseKernel.version}-surface-custom";
  configfile = ./surface-6.8.config;
  allowImportFromDerivation = true;
  kernelPatches = callPackage ./surface-patches.nix {};
}
