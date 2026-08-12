{self, ...}: {
  den.aspects.staging.nixos = {
    imports = [
      self.modules.nixos.staging-hardware
    ];
  };
}
