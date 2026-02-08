{
  flake.modules.nixos.configuration-packages-default = {
    self,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    environment.systemPackages = with pkgs; [
      self.packages.${system}.zsh
      self.packages.${system}.nushell
      self.packages.${system}.neovim
    ];

    environment.variables.EDITOR = "nvim";
    users.defaultUserShell = self.packages.${system}.zsh;
  };
}
