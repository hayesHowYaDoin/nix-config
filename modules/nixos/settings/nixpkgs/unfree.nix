_: {
  flake.modules.nixos.nixpkgs-unfree = {
    nixpkgs.config.allowUnfree = true;
  };
}
