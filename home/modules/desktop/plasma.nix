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
          location = "bottom";
          opacity = "translucent";
          height = 45;
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }
            "org.kde.plasma.pager"
            "org.kde.plasma.marginsseparator"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General = {
                  launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:com.mitchellh.ghostty.desktop"
                    "applications:code.desktop"
                    "applications:firefox.desktop"
                    "applications:spotify.desktop"
                    "applications:steam.desktop"
                  ];
                };
              };
            }
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.networkmanagement"
                ];
                hidden = [
                  "org.kde.plasma.volume"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.brightness"
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "sunday";
                time.format = "12h";
              };
            }
          ];
        }
      ];

      kwin.virtualDesktops = {
        number = 4;
        rows = 2;
      };
    };
  };
}