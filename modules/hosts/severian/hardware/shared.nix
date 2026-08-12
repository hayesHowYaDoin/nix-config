{self, ...}: {
  flake.modules.nixos.severian-hardware = {
    imports = with self.modules.nixos; [
      nvidia
    ];
  };
}
