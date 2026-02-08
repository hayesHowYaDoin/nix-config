{
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    mkNeovim = import ./_lib/mkNeovim.nix;
  in {
    packages.neovim =
      (mkNeovim {
        inherit pkgs;
        inherit (inputs) nvf;
      }).neovim;
  };
}
