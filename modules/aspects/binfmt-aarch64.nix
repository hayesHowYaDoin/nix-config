{
  # Enables emulated aarch64 builds on x86_64 — used for building
  # Raspberry Pi images without cross-compiling manually.
  den.aspects.binfmt-aarch64.nixos = {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
