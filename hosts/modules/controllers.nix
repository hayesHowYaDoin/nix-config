{ pkgs, ... }:

{
  # Enable GameCube controller support
  services.udev.packages = [ pkgs.dolphin-emu ];
}
