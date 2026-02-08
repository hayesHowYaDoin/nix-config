{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.sevarian = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit self inputs;};
    modules = [
      self.modules.nixos.sevarian-configuration
      self.modules.nixos.sevarian-hardware
    ];
  };
}
