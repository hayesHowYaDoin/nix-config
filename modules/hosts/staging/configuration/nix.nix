{
  flake.modules.nixos.staging-configuration = {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "jordan"];
    };
  };
}
