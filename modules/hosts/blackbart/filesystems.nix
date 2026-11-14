{
  den.aspects.blackbart.nixos = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/f3465b22-80b5-4cab-bad8-4d4527a5f39d";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/A71B-DD1A";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/be800340-bc83-4f25-be60-397d5ad8dbe5";}
    ];
  };
}
