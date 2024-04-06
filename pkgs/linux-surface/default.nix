{ lib
, callPackage
, linux
, fetchFromGitHub
, linuxManualConfig
, ... }:

linuxManualConfig {
  inherit (linux) src modDirVersion;
  version = (linux.version + "-surface-custom");
  configfile = ./surface-6.8.config;
  allowImportFromDerivation = true;
  kernelPatches = callPackage ./surface-patches.nix {};
}
