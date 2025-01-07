{ config, lib, pkgs, user, ...}:

with lib; let
  cfg = config.features.desktop.hyprland;
  wallpaper = "/home/jordan/.config/nix-config/home/assets/wallpaper.jpeg";
in {
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };
        
        # Autostart
        exec-once = [
          "waybar"
          "hyprpaper"
          "hypridle"
          "dbus-update-activation-environment --all"
        ];

        # Programs
        "$terminal" = "kitty";
        "$fileManager" = "nautilus";
        "$menu" = "rofi -show drun";
        "$browser" = "firefox";

        # Modifier keys
        "$mainMod" = "SUPER";

        ### WINDOW ##############################################################

        general  = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";
        };

        decoration = {
          rounding = 10;

          # Applies universally; see windowrulev2 for alternative
          # active_opacity = "0.95";
          # inactive_opacity = "0.95";

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(ffffffff)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = "0.1696";
          };
        };

        windowrulev2 = [
          "float,class:^(Lxappearance)$"
          "opacity 0.8 0.8,class:^(kitty)$"
          "opacity 1 1,class:^(firefox)"
          "noborder,fullscreen:1"
        ];

        ### KEYBINDS ############################################################

        bind = [
          # General
          "$mainMod, T, exec, $terminal"
          "$mainMod, Q, killactive"
          "$mainMod, F, exec, $fileManager"
          "$mainMod, TAB, exec, $menu"
          "$mainMod, J, togglesplit"
          "$mainMod, B, exec, $browser"
          "$mainMod, L, exec, hyprlock"

          # Focus
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Navigation
          "$mainMod, SPACE, togglefloating"

          # Resize window
          "$mainMod SHIFT, left, resizeactive, -40 0"
          "$mainMod SHIFT, right, resizeactive, 40 0"
          "$mainMod SHIFT, up, resizeactive, 0 -40"
          "$mainMod SHIFT, down, resizeactive, 0 40"

          # Switch workspace
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"

          "$mainMod, KP_End, workspace, 1"
          "$mainMod, KP_Down, workspace, 2"
          "$mainMod, KP_Next, workspace, 3"
          "$mainMod, KP_Left, workspace, 4"
          "$mainMod, KP_Begin, workspace, 5"
          "$mainMod, KP_Right, workspace, 6"
          "$mainMod, KP_Home, workspace, 7"
          "$mainMod, KP_Up, workspace, 8"
          "$mainMod, KP_Prior, workspace, 9"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Move active window to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"

          "$mainMod SHIFT, KP_End, movetoworkspace, 1"
          "$mainMod SHIFT, KP_Down, movetoworkspace, 2"
          "$mainMod SHIFT, KP_Next, movetoworkspace, 3"
          "$mainMod SHIFT, KP_Left, movetoworkspace, 4"
          "$mainMod SHIFT, KP_Begin, movetoworkspace, 5"
          "$mainMod SHIFT, KP_Right, movetoworkspace, 6"
          "$mainMod SHIFT, KP_Home, movetoworkspace, 7"
          "$mainMod SHIFT, KP_Up, movetoworkspace, 8"
          "$mainMod SHIFT, KP_Prior, movetoworkspace, 9"

          # Screen shot
          "$mainMod, S, exec, hyprctl keyword animation 'fadeOut,0,0,default'; grimshot --notify copy active; hyprctl keyword animation 'fadeOut,1,4,default'"
          "$mainMod SHIFT, S, exec, grimshot savecopy area - | swappy -f - -o ~/Photos/screenshot-$(date +'%d-%m-%Y_%H:%M').png"

          # Screen recorder
          "$mainMod SHIFT, R, exec, wf-recorder -a -f ~/Video/recording.mkv & notify-send 'Recording Started' -i -u -A '^C ,stop' -t 0 -i ~/icons/rec-button.png"

          # Emoji selector
          "$mainMod SHIFT, E, exec, rofimoji"
        ];

        bindm = [
          # Move window
          "$mainMod, mouse:272, movewindow"

          # Resize window
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          # Multimedia keys
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        bindl = [
          # Requires playerctl
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        preload = "${wallpaper}";
        wallpaper = ",${wallpaper}";
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          no_fade_in = false;
          disable_loading_bar = true;
          grace = 0;
        };
        background = [{
          monitor = "";
          path = "${wallpaper}";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 1;
          blur_size = 0;
          brightness = 0.2;
        }];
        input-field = [
          {
            monitor = "";
            size = "250, 60";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.5)";
            font_color = "rgb(200, 200, 200)";
            fade_on_empty = true;
            # placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
            hide_input = false;
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 120;
            position = "0, 0";
            valign = "center";
            halign = "center";
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "hyprlock";
          after_sleep_cmd = "hyprctl dispatch dpms on"; # Avoids double key press
        };
        listener = [
          {
            timeout = 60;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 150;
            on-timeout = "hyprlock";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}