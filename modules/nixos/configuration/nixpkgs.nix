_: {
  flake.modules.nixos.configuration-nixpkgs = {
    nixpkgs.config.allowUnfree = true;
  };
}
