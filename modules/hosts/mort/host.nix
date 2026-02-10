{
  self,
  inputs,
  ...
}: let
  system = "aarch64-linux";
in {
  flake.nixosConfigurations.mort = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {inherit self inputs;};
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      self.modules.nixos.mort-configuration
      self.modules.nixos.mort-hardware
    ];
  };
}
