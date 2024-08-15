{ config, lib, pkgs, ... }: {

  hardware.firmware = with pkgs; [
    ipu6-camera-bins
    ivsc-firmware
  ];

}
