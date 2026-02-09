{inputs, ...}: {
  flake.modules.nixos.mort-hardware = {
    imports = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-3
    ];
  };
}
