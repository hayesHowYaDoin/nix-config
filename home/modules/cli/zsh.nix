{ config, lib, user, ...}:

with lib; let
  cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake";
        home = "home-manager switch --flake";
      };
    };
  };

}