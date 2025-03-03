{ config, pkgs, user, lib, ... }:

with lib; let
  cfg = config.features.desktop.ghostty;
in
{
  options.features.desktop.ghostty.enable = mkEnableOption "Ghostty configuration";

  config = mkIf cfg.enable {
    programs.ghostty.enable = true;
  };
}
