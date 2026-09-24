{
  hayes.hyprland-session = {
    mainMod ? "SUPER",
    terminal ? "ghostty",
    launcher ? "fuzzel",
    fileManager ? "nautilus",
    monitors ? [",preferred,auto,1"],
    extraSettings ? {},
    extraBinds ? [],
    ...
  }: {
    homeManager = {lib, ...}: {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;

        settings = lib.recursiveUpdate {
          monitor = monitors;

          "$mod" = mainMod;
          "$terminal" = terminal;
          "$launcher" = launcher;
          "$fileManager" = fileManager;

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "MOZ_ENABLE_WAYLAND,1"
            "NIXOS_OZONE_WL,1"
          ];

          input = {
            kb_layout = "us";
            follow_mouse = 1;
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
              tap-to-click = true;
            };
          };

          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            "col.active_border" = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
            "col.inactive_border" = "rgba(1e1e2eaa)";
            layout = "dwindle";
            resize_on_border = true;
            allow_tearing = false;
          };

          decoration = {
            rounding = 10;
            active_opacity = 1.0;
            inactive_opacity = 0.95;
            blur = {
              enabled = true;
              size = 6;
              passes = 2;
              new_optimizations = true;
              ignore_opacity = true;
            };
            shadow = {
              enabled = true;
              range = 8;
              render_power = 2;
              color = "rgba(00000055)";
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };

          dwindle.preserve_split = true;

          master.new_status = "master";

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            force_default_wallpaper = 0;
          };

          bind =
            [
              "$mod, RETURN, exec, $terminal"
              "$mod, D, exec, $launcher"
              "$mod, E, exec, $fileManager"
              "$mod, Q, killactive,"
              "$mod SHIFT, E, exit,"
              "$mod, V, togglefloating,"
              "$mod, F, fullscreen,"
              "$mod, P, pseudo,"
              "$mod, J, layoutmsg, togglesplit"

              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"

              "$mod SHIFT, left, movewindow, l"
              "$mod SHIFT, right, movewindow, r"
              "$mod SHIFT, up, movewindow, u"
              "$mod SHIFT, down, movewindow, d"

              ", PRINT, exec, grim -g \"$(slurp)\" - | wl-copy"
              "$mod, PRINT, exec, grim - | wl-copy"
              "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"

              "$mod, L, exec, hyprlock"
            ]
            ++ (builtins.concatLists (builtins.genList (
                i: let
                  ws = toString (i + 1);
                  key =
                    if i == 9
                    then "0"
                    else toString (i + 1);
                in [
                  "$mod, ${key}, workspace, ${ws}"
                  "$mod SHIFT, ${key}, movetoworkspace, ${ws}"
                ]
              )
              10))
            ++ extraBinds;

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
            ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
          ];

          bindl = [
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          exec-once = [];
        }
        extraSettings;
      };
    };
  };
}
