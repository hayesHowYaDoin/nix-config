{self, ...}: {
  flake.modules.nixos.mort-configuration = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
    ];
  };
}
