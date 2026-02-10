{self, ...}: {
  flake.modules.nixos.mort-configuration = {
    imports = with self.modules.nixos; [
      time
    ];
  };
}
