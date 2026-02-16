{
  flake.modules.nixos.mort-configuration = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libraspberrypi
    ];
  };
}
