{self, ...}: {
  flake.modules.nixos.severian-configuration = {
    imports = [
      self.modules.nixos.jordan
    ];
  };
}
