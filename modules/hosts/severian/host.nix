{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.severian = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit self inputs;};
    modules = [
      self.modules.nixos.severian-configuration
      self.modules.nixos.severian-hardware
    ];
  };
}
