{
  flake.modules.nixos.default-shell = {
    self,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    environment.systemPackages = with pkgs; [
      self.packages.${system}.zsh
      self.packages.${system}.nushell
    ];

    users.defaultUserShell = self.packages.${system}.zsh;
  };
}
