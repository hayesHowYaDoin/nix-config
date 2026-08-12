{self, ...}: {
  flake.modules.nixos.staging-configuration = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
      ssh
      time
    ];
  };
}
