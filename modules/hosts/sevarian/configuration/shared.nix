{self, ...}: {
  flake.modules.nixos.sevarian-hardware = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
      podman
      sleepless
      time
    ];
  };
}
