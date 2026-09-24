{
  hayes.flakes.nixos = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
