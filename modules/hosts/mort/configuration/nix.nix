{self, ...}: {
  flake.modules.nixos.mort-configuration = {
    imports = with self.modules.nixos; [
      nixpkgs-unfree
    ];

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "nixos"];
    };
  };
}
