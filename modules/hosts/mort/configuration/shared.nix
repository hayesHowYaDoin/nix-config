{self, ...}: {
  flake.modules.nixos.mort-hardware = {
    imports = with self.modules.nixos; [
      configuration-time
      configuration-nixpkgs
    ];
  };
}
