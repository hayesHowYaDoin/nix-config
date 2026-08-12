{self, ...}: {
  flake.modules.nixos.severian-hardware = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
      podman
      sleepless
      ssh
      time
    ];
  };
}
