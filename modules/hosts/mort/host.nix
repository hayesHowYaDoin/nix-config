{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.mort = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {inherit self inputs;};
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      self.modules.nixos.mort-configuration
      self.modules.nixos.mort-hardware
    ];
  };
}
