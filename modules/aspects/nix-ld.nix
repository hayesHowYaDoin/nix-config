{
  # Dynamic linker for non-Nix binaries (needed for VSCode extensions,
  # some npm packages, downloaded proprietary binaries, etc.).
  hayes.nix-ld.nixos = {
    programs.nix-ld.enable = true;
  };
}
