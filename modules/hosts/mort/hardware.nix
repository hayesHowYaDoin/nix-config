{inputs, ...}: {
  den.aspects.mort.nixos = {
    imports = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      inputs.nixos-hardware.nixosModules.raspberry-pi-3
    ];

    boot = {
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
      kernelParams = ["console=ttyS1,115200n8"];
      zfs.forceImportRoot = false;
    };

    environment.systemPackages = [inputs.nixpkgs.legacyPackages.aarch64-linux.libraspberrypi];
  };
}
