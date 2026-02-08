_: {
  flake.modules.nixos.kenny = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };
}
