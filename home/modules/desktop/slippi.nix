{ config, lib, ... }:

with lib; let
  cfg = config.features.desktop.slippi;
in
{
  options.features.desktop.slippi.enable = mkEnableOption "Project Slippi configuration";

  config = mkIf cfg.enable {
    slippi-launcher = {
      enable = true;
      launchMeleeOnPlay = false;
      isoPath = "/mnt/Games/Roms/GCN/game.iso";
      useMonthlySubfolders = true;

      netplayHash = "sha256-QsvayemrIztHSVcFh0I1/SOCoO6EsSTItrRQgqTWvG4=";
    };
  };
}
