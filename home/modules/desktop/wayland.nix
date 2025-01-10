# Heavily inspired by:
# https://github.com/nomadics9/nixcfg/blob/f2914acae6d88bf6569adc2d70d34aed11de0652/home/features/desktop/wayland.nix

{ config, lib, pkgs, ...}:

with lib; let
  cfg = config.features.desktop.wayland;
in
{
  options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 52;
          layer = "top";
          modules-left = [ "custom/launcher" "cpu" "memory" "hyprland/workspaces" ];
          # modules-center = [ "mpris" ]; # TODO: Fix hyprbar crashing/failing to launch due to mpris
          modules-right = [ "network" "pulseaudio" "custom/weather" "clock" ];

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
            # tooltip-format = "Volume {volume}%";
          };

          "network" = {
            format-wifi = "<big>{icon}</big>";
            format-ethernet = "󰈀";
            format-disconnected = "󰤭";
            tooltip-format = "{essid}\n⬆️: {bandwidthUpBytes}\n⬇️: {bandwidthDownBytes}";
            interval = 1;
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          };

          "clock" = {
            format = "{:%H:%M}";
            format-alt = "{:%b %d %Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          # "mpris" = {
          #   format = "{player_icon} {title}";
          #   format-paused = " {status_icon} <i>{title}</i>";
          #   max-length = 80;
          #   interval = 1;
          #   player-icons = {
          #     default = "▶";
          #     mpv = "🎵";
          #   };
          #   status-icons = {
          #     paused = "⏸";
          #   };
          # };
        };
      };


      style = /*css*/ '' 
  
        * {
          font-family: JetBrains Mono, JetBrainsMono Nerd Font, Material Design Icons;
          font-size: 17px; 
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
        #custom-weather {
          background-color: #222034;
          font-size: 14px;
          color: #8a909e;
          padding: 3px 8px;
          border-radius: 8px;
          margin: 8px 2px;
        }

        /* Styling for Network and Pulseaudio group*/
        #network,
        #pulseaudio {
          background-color: #222034;
          font-size: 14px;
          color: #8a909e;
          padding: 3px 8px;
          margin: 8px 0px;
        }

        /* Module-specific colors for Network, Pulseaudio, Backlight, Battery */
        #network,
        #pulseaudio {
          color: #5796E0;
          padding-right: 14px
        }

        /* Pulseaudio mute state */
        #pulseaudio.muted { color: #fb958b; }

        /* Rounded corners for specific group elements */
        #network { border-radius: 8px 0 0 8px; }
        #pulseaudio { border-radius: 0 8px 8px 0; }

        /* Temperature, CPU, and Memory colors */
        #cpu { color: #fb958b; }
        #memory { color: #a1c999; }

        /* Workspaces active button styling */
        #workspaces button {
          color: #5796E0;
          border-radius: 8px;
          box-shadow: inset 0 -3px transparent;
          padding: 3px 4px;
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
          font-size: 22px;
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
          font-size: 14px;
          }

  '';
    };
  };
}