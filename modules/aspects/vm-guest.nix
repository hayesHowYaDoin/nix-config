{
  den.aspects.vm-guest.nixos = {
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
    ];

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
