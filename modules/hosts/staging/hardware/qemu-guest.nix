_: {
  flake.modules.nixos.staging-hardware = {
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
    ];

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
