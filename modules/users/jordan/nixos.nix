{
  flake.modules.nixos.jordan = {
    pkgs,
    self,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    userName = "jordan";
  in {
    users.users.jordan = {
      isNormalUser = true;
      description = userName;
      extraGroups = ["dialout" "networkmanager" "wheel"];
      shell = self.packages.${system}.zsh;
    };
  };
}
