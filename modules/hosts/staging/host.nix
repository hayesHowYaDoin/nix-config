{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.staging = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit self inputs;};
    modules = [
      self.modules.nixos.staging-configuration
      self.modules.nixos.staging-hardware
    ];
  };
}
