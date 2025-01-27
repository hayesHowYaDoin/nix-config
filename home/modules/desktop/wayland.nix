# Heavily inspired by:
# https://github.com/nomadics9/nixcfg/blob/f2914acae6d88bf6569adc2d70d34aed11de0652/home/features/desktop/wayland.nix

{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.features.desktop.wayland;

  medium_font = builtins.toString(builtins.floor(cfg.height / 2.5));
  large_font = builtins.toString(builtins.floor(cfg.height / 2.0));
  vertical_pad = builtins.toString(builtins.floor(cfg.height / 12.0));
in
{
  options.features.desktop.wayland.enable = mkEnableOption "Wayland tools and config";
  options.features.desktop.wayland.height = mkOption {
    type = types.int;
    example = 30;
    description = "Height of the Waybar in pixels";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = cfg.height;
          layer = "top";
          modules-left = [ "custom/launcher" "cpu" "memory" "hyprland/workspaces" ];
          modules-center = [ "mpris" ];
          modules-right = [ "pulseaudio" "network" "battery" "custom/weather" "clock" ];

          "custom/launcher" = {
            format = "󱄅";
            on-click = "rofi -show drun";
          };

          "cpu" = {
            interval = 10;
            format = "CPU: {}%";
            max-length = 10;
          };

          "memory" = {
            interval = 10;
            format = "RAM: {}%";
            max-length = 10;
          };

          "hyprland/workspaces" = {
            format = "{name}";
            all-outputs = true;
            on-click = "activate";
            format-icons = {
              active = "󱎴";
              default = "󰍹";
            };
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
              "6" = [ ];
              "7" = [ ];
              "8" = [ ];
              "9" = [ ];
            };
          };
          
          "custom/weather" = {
            format = "{}°F";
            tooltip = true;
            interval = 3600;
            exec = "wttrbar --location 'Fort Collins' --fahrenheit";
            return-type = "json";
          };

          "pulseaudio" = {
            format = "<big>{icon}</big> {volume}%";
            format-muted = "<big>󰖁</big> {volume}%";
            format-icons = {
              default = [ "" "" "󰕾" ];
            };
            on-click = "pamixer -t";
            on-scroll-up = "pamixer -i 1";
            on-scroll-down = "pamixer -d 1";
            on-click-right = "exec pavucontrol";
            tooltip-format = "Volume {volume}%";
          };

          "network" = {
            format-wifi = "<big>{icon}</big> ";
            format-ethernet = "󰈀";
            format-disconnected = "󰤭";
            tooltip-format = "{essid}\n⬆️: {bandwidthUpBytes}\n⬇️: {bandwidthDownBytes}";
            interval = 1;
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          };

          "clock" = {
            format = "{:%A, %d %B | %H:%M}";
            format-alt = "{:%b %d %Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "mpris" = {
            format = "{player_icon} {title}";
            format-paused = " {status_icon} <i>{title}</i>";
            max-length = 80;
            interval = 1;
            player-icons = {
              default = "▶";
              mpv = "🎵";
            };
            status-icons = {
              paused = "⏸";
            };
          };

          "battery" = {
            bat = "BAT1";
            adapter = "ADP1";
            interval = 60;
            states = {
              warning = 15;
              critical = 7;
            };
            max-length = 20;
            format = "{icon}";
            format-warning = "{icon}";
            format-critical = "{icon}";
            format-charging = "<span font-family='Font Awesome 6 Free'></span>";
            format-plugged = "󰚥";
            format-notcharging = "󰚥";
            format-full = "󰂄";
            format-alt = "<small>{capacity}%</small>";
            format-alt-warning = "<small>{capacity}%</small>";
            format-critical-alt = "<small>{capacity}%</small>";
            format-icons = [ "󱊡" "󱊢" "󱊣" ];
          };
        };
      };


      style = /*css*/ '' 
  
        * {
          font-family: JetBrains Mono, JetBrainsMono Nerd Font, Material Design Icons;
          font-size: ${medium_font}px; 
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          background-color: rgba(26, 27, 38, 0.5);          
          color: #ffffff;
          transition-property: background-color;
          transition-duration: 0.5s;
        }

        /* General styling for individual modules */
        #clock,
        #temperature,
        #mpris,
        #cpu,
        #memory,
        #tray,
        #workspaces,
        #custom-launcher,
        #network,
        #pulseaudio,
        #battery,
        #custom-weather {
          background-color: #222034;
          font-size: ${medium_font}px;
          color: #8a909e;
          padding: ${vertical_pad}px 8px;
          border-radius: 8px;
          margin: 3px 2px;
        }

        /* Module-specific colors for Network, Pulseaudio, Backlight, Battery */
        #network,
        #pulseaudio,
        #battery {
          color: #5796E0;
        }

        /* Battery state-specific colors */
        #battery.warning { color: #ecd3a0; }
        #battery.critical:not(.charging) { color: #fb958b; }

        /* Pulseaudio mute state */
        #pulseaudio.muted { color: #fb958b; }

        /* Temperature, CPU, and Memory colors */
        #cpu { color: #fb958b; }
        #memory { color: #a1c999; }

        /* Workspaces active button styling */
        #workspaces button {
          color: #5796E0;
          border-radius: 8px;
          box-shadow: inset 0 -3px transparent;
          padding: ${vertical_pad}px 4px;
          transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
        }
        #workspaces button.active {
          color: #ecd3a0;
          font-weight: bold;
          border-radius: 8px;
          transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
        }

        /* Custom launcher */
        #custom-launcher {
          color: #5796E0;
          font-size: ${large_font}px;
          padding-right: 14px;
        }

        /* Tooltip styling */
        tooltip {
          border-radius: 15px;
          padding: 15px;
          background-color: #222034;
        }
        tooltip label {
          padding: 5px;
          font-size: ${medium_font}px;
        }
  '';
    };
  };
}
