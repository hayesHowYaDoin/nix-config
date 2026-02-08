{self, ...}: {
  flake.modules.nixos.sevarian-configuration = {
    imports = [
      self.modules.nixos.jordan
    ];
  };
}
