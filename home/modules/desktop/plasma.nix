{ config, lib, pkgs, ...}:

with lib; let
  cfg = config.features.desktop.plasma;
in
{
  options.features.desktop.plasma.enable =
    mkEnableOption "KDE Plasma Configuration";

  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      panels = [
        {
          location = "top";
        }
      ];
    };
  };
}