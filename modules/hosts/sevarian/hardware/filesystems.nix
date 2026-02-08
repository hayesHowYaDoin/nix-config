_: {
  flake.modules.nixos.sevarian-hardware = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/b0407a50-9dc2-44aa-b10b-88993b3d34ea";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/E7CC-481C";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
      "/mnt/d" = {
        # Mount using first drive - btrfs automatically uses both drives in RAID 1
        device = "/dev/disk/by-id/ata-WDC_WD120EFGX-68CPHN0_WD-B015YWGD";
        fsType = "btrfs";
        options = [
          "compress=zstd:3"
          "space_cache=v2"
          "noatime" # Don't update access times
          "commit=120" # Sync metadata every 120s
          "nofail" # Don't fail boot if unavailable
          "x-systemd.device-timeout=10"
          "x-systemd.automount"
        ];
      };
    };
  };
}
