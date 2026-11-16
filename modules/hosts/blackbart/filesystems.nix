{
  den.aspects.blackbart.nixos = {pkgs, ...}: {
    environment.systemPackages = [pkgs.cifs-utils];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/f3465b22-80b5-4cab-bad8-4d4527a5f39d";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/A71B-DD1A";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    # Sevarian's media share over the tailnet. Automount so we don't block
    # boot if sevarian is briefly unreachable; mounts on first access,
    # unmounts after idle.
    fileSystems."/mnt/media" = {
      device = "//sevarian/media";
      fsType = "cifs";
      options = [
        "guest"
        "vers=3.0"
        "nofail"
        "_netdev"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.device-timeout=30"
        "x-systemd.mount-timeout=30"
        "file_mode=0666"
        "dir_mode=0777"
      ];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/be800340-bc83-4f25-be60-397d5ad8dbe5";}
    ];
  };
}
