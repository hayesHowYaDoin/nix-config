{ pkgs, lib, config, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ${../../assets/wallpaper.jpg} &
  '';
in {
  wayland.windowManager.hyprland = {
    # Allow home-manager to configure hyprland
    enable = true;

    settings = {
      # Autostart
      exec-once = ''${startupScript}/bin/start'';

      # Programs
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun";

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
        rounding = 5;

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
      # windowrulev2 = float,class:^(Lxappearance)$
      # windowrulev2 = opacity 0.8 0.8,title:^(rofi)(.*)$
      # windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
      # windowrulev2 = opacity 0.8 0.8,class:^(wofi)$
      # windowrulev2 = opacity 0.8 0.8,class:^(thunar)$
      # windowrulev2 = maximize,class:^(winbox.exe)$
      # # windowrulev2 = maximize,class:^(chromium)$
      # # windowrulev2 = noanim,class:^(kitty)$
      # windowrulev2 = maximize,title:^(nvim)$
      # windowrulev2 = float,class:^(org.telegram.desktop|vlc)$
      # windowrulev2 = float,title:^(ranger)$
      # windowrulev2 = size 60% 80%,class:^(org.telegram.desktop|vlc)$
      # windowrulev2 = size 60% 80%,title:^(Open Files|ranger)$
      # windowrulev2 = center,class:^(org.telegram.desktop|Open Files|ranger|vlc)$
      # windowrulev2 = opacity 0.8 0.8,title:^(Open Files|ranger)$
      # windowrulev2 = opacity 1 1,class:^(kitty)$,title:^(nvim)(.*)$ # disable opacity while opening neovim
      # # windowrulev2 = bordercolor rgb(000000) rgb(000000),fullscreen:1
      # windowrulev2 = noborder,fullscreen:1 # remove border on fullscreen

      ### KEYBINDS ############################################################

      bind = [
        # General
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, S, exec, $fileManager"
        "$mainMod, TAB, exec, $menu"
        "$mainMod, J, togglesplit"

        # Focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

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
        "$mainMod, 0, workspace, 10"

        "$mainMod, KP_End, workspace, 1"
        "$mainMod, KP_Down, workspace, 2"
        "$mainMod, KP_Next, workspace, 3"
        "$mainMod, KP_Left, workspace, 4"
        "$mainMod, KP_Begin, workspace, 5"
        "$mainMod, KP_Right, workspace, 6"
        "$mainMod, KP_Home, workspace, 7"
        "$mainMod, KP_Up, workspace, 8"
        "$mainMod, KP_Prior, workspace, 9"
        "$mainMod, KP_Insert, workspace, 10"

        "$mainMod SHIFT, right, workspace, e+1"
        "$mainMod SHIFT, left, workspace, e-1"

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
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod SHIFT, KP_End, movetoworkspace, 1"
        "$mainMod SHIFT, KP_Down, movetoworkspace, 2"
        "$mainMod SHIFT, KP_Next, movetoworkspace, 3"
        "$mainMod SHIFT, KP_Left, movetoworkspace, 4"
        "$mainMod SHIFT, KP_Begin, movetoworkspace, 5"
        "$mainMod SHIFT, KP_Right, movetoworkspace, 6"
        "$mainMod SHIFT, KP_Home, movetoworkspace, 7"
        "$mainMod SHIFT, KP_Up, movetoworkspace, 8"
        "$mainMod SHIFT, KP_Prior, movetoworkspace, 9"
        "$mainMod SHIFT, KP_Insert, movetoworkspace, 10"
      ];

      bindm = [
         # Move window
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, movewindow"
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
}