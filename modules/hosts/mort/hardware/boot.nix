_: {
  flake.modules.nixos.mort-hardware = {
    boot = {
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
      kernelParams = ["console=ttyS1,115200n8"];
    };
  };
}
