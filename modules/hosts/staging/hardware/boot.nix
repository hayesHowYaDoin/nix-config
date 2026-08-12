{
  den.aspects.staging.nixos = {pkgs, ...}: {
    boot = {
      loader.grub = {
        enable = true;
        device = "/dev/vda";
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = ["kvm-intel"];
      initrd.availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sr_mod"
        "virtio_blk"
      ];
    };
  };
}
