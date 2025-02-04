{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.features.cli.helix;
in
{
  options.features.cli.helix.enable =
    mkEnableOption "Installs and configures the helix editor";

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      settings = {
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
        {
          name = "python";
          auto-format = true;
          formatter.command = "${pkgs.black}/bin/black";
        }
        {
          name = "json";
          auto-format = true;
          formatter.command = "${pkgs.jq}/bin/jq";
        }
        {
          name = "yaml";
          auto-format = true;
          formatter.command = "${pkgs.yq}/bin/yq";
        }
        {
          name = "markdown";
          auto-format = true;
          formatter.command = "${pkgs.marksman}/bin/marksman";
        }
      ];
    };
  };
}