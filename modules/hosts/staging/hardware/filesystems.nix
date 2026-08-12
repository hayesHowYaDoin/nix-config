{
  den.aspects.staging.nixos = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/63400356-8912-4bf8-9aaa-617072aaefba";
      fsType = "ext4";
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/3b964351-ed0c-4654-baa2-8b82b771dc7a";}
    ];
  };
}
