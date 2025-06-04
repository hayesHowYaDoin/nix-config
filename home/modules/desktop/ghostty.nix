{ config, pkgs, user, lib, ... }:

with lib; let
  cfg = config.features.desktop.ghostty;
in
{
  options.features.desktop.ghostty.enable = mkEnableOption "Ghostty configuration";

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      # settings = {
        # background-opacity = 0.8;
        # custom-shader = builtins.toString ../../assets/shaders/starfield-colors.glsl;
        # custom-shader-animation = "always";
      # };
    };
  };
}
