{
  flake.modules.nixos.default-editor = {
    self,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    environment.systemPackages = with pkgs; [
      self.packages.${system}.neovim
    ];

    environment.variables.EDITOR = "nvim";
  };
}
