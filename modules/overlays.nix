{self, ...}: {
  flake.overlays.default = final: _prev: let
    inherit (final.stdenv.hostPlatform) system;
  in {
    inherit (self.packages.${system}) zsh;
    inherit (self.packages.${system}) nushell;
    inherit (self.packages.${system}) neovim;
  };
}
