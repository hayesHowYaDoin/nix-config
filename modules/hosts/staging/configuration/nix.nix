{
  den.aspects.staging.nixos = {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "jordan"];
    };
  };
}
