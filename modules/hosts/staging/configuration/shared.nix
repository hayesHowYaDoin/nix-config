{self, ...}: {
  den.aspects.staging.nixos = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
      ssh
      time
    ];
  };
}
