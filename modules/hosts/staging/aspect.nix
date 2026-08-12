{self, ...}: {
  den.aspects.staging.nixos = {
    imports = [
      self.modules.nixos.staging-configuration
      self.modules.nixos.staging-hardware
    ];
  };
}
