{ config, pkgs, user, lib, ... }:

with lib; let
  cfg = config.features.desktop.kitty;
in
{
  options.features.desktop.kitty.enable = mkEnableOption "Kitty configuration";

  config = mkIf cfg.enable {
    programs.kitty.enable = true;
  };
}
