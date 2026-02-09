{self, ...}: {
  flake.modules.nixos.sevarian-hardware = {
    imports = with self.modules.nixos; [
      nvidia
    ];
  };
}
