{self, ...}: {
  flake.modules.nixos.mort-configuration = {
    imports = [
      self.modules.nixos.jordan
    ];
  };
}
