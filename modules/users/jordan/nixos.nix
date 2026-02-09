_: {
  flake.modules.nixos.jordan = {
    self,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    userName = "jordan";
  in {
    users.users.jordan = {
      isNormalUser = true;
      description = userName;
      password = "default"; # TODO: This won't be this way for long, so stop salivating over it.
      extraGroups = ["dialout" "networkmanager" "wheel"];
      shell = self.packages.${system}.zsh;
    };
  };
}
