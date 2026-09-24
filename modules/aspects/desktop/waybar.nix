{
  hayes.waybar.homeManager = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
        };

        "hyprland/window" = {
          max-length = 60;
          separate-outputs = true;
        };

        tray.spacing = 8;

        clock = {
          format = "{:%H:%M  %a %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = " {usage}%";
          interval = 5;
        };

        memory = {
          format = " {}%";
          interval = 5;
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = "睊";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons.default = ["" "" ""];
          on-click = "pavucontrol";
        };
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(30, 30, 46, 0.85);
          color: #cdd6f4;
        }

        #workspaces button {
          padding: 0 8px;
          color: #a6adc8;
          background: transparent;
          border-bottom: 2px solid transparent;
        }

        #workspaces button.active {
          color: #89b4fa;
          border-bottom: 2px solid #89b4fa;
        }

        #workspaces button:hover {
          background: rgba(137, 180, 250, 0.1);
        }

        #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
          padding: 0 10px;
        }

        #battery.warning:not(.charging) {
          color: #f9e2af;
        }

        #battery.critical:not(.charging) {
          color: #f38ba8;
        }
      '';
    };
  };
}
