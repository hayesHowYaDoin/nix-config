{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.kenny = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit self inputs;};
    modules = [
      self.modules.nixos.kenny
    ];
  };
}
