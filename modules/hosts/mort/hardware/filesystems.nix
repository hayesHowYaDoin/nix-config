_: {
  flake.modules.nixos.mort-hardware = {
    # Filesystem configuration is handled by sd-image-aarch64.nix module
    # The SD image module automatically creates the root filesystem
  };
}
