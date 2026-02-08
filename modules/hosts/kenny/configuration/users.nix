{self, ...}: {
  flake.modules.nixos.kenny = {
    imports = [
      self.modules.nixos.jordan
    ];
  };
}
