{self, ...}: {
  flake.modules.nixos.sevarian-hardware = {
    imports = with self.modules.nixos; [
      configuration-packages-default
      configuration-podman
      configuration-sleepless
      configuration-time
      configuration-nixpkgs
    ];
  };
}
