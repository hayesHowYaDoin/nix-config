{
  hayes.gnome = {
    autoLoginUser ? null,
    keyboardLayout ? "us",
    keyboardVariant ? "",
    background ? null,
    backgroundDark ? null,
    ...
  }: {
    nixos = {
      services = {
        displayManager = {
          gdm.enable = true;
          autoLogin =
            if autoLoginUser != null
            then {
              enable = true;
              user = autoLoginUser;
            }
            else {enable = false;};
          defaultSession = "gnome";
        };

        desktopManager.gnome.enable = true;

        xserver = {
          enable = true;
          xkb = {
            layout = keyboardLayout;
            variant = keyboardVariant;
          };
        };
      };
    };

    homeManager = {
      config,
      lib,
      pkgs,
      ...
    }:
      with lib; let
        hasColorScheme = config.colorScheme or null != null;
        stylixManagesTheme = config.stylix.enable or false;

        mkColor = c: "#${c}";
        mkRgba = c: alpha: let
          r = builtins.substring 0 2 c;
          g = builtins.substring 2 2 c;
          b = builtins.substring 4 2 c;
        in "rgba(${r}, ${g}, ${b}, ${alpha})";

        colors = optionalAttrs hasColorScheme (with config.colorScheme.palette; {
          bg = mkColor base00;
          bg1 = mkColor base01;
          bg2 = mkColor base02;
          bg3 = mkColor base03;

          fg = mkColor base05;
          fg_dim = mkColor base04;
          fg_bright = mkColor base06;

          red = mkColor base08;
          orange = mkColor base09;
          yellow = mkColor base0A;
          green = mkColor base0B;
          cyan = mkColor base0C;
          blue = mkColor base0D;
          purple = mkColor base0E;
          brown = mkColor base0F;

          bg_alpha_50 = mkRgba base00 "0.5";
          bg_alpha_80 = mkRgba base00 "0.8";
          bg_alpha_90 = mkRgba base00 "0.9";
        });

        shellCss = optionalString hasColorScheme ''
          /* ===================================================================
           * GNOME Shell Theme - Powered by nix-colors
           * Base16 Color Scheme: ${config.colorScheme.name}
           * =================================================================== */

          stage {
            color: ${colors.fg};
          }

          #panel {
            background-color: transparent;
            color: ${colors.fg};
            height: 32px;
          }

          .panel-corner {
            -panel-corner-background-color: transparent;
          }

          .panel-button {
            color: ${colors.fg};
            font-weight: bold;
            padding: 0 12px;
          }

          .panel-button:hover {
            background-color: ${colors.bg2};
            color: ${colors.fg_bright};
          }

          .panel-button:active,
          .panel-button:focus,
          .panel-button:checked {
            background-color: ${colors.bg3};
            color: ${colors.fg_bright};
          }

          .overview {
            background-color: ${colors.bg_alpha_90};
          }

          #dash {
            background-color: ${colors.bg1};
            border-radius: 8px;
            padding: 8px 0;
          }

          .dash-item-container .app-well-app,
          .dash-item-container .show-apps {
            padding: 6px;
          }

          .dash-item-container .app-well-app:hover,
          .dash-item-container .show-apps:hover {
            background-color: ${colors.bg2};
            border-radius: 8px;
          }

          .app-well-app {
            background-color: transparent;
            border-radius: 8px;
          }

          .app-well-app:hover {
            background-color: ${colors.bg2};
          }

          .app-well-app:active,
          .app-well-app:checked {
            background-color: ${colors.bg3};
          }

          .search-entry {
            background-color: ${colors.bg1};
            color: ${colors.fg};
            border-color: ${colors.bg2};
            border-radius: 8px;
            padding: 8px 12px;
          }

          .search-entry:focus {
            border-color: ${colors.blue};
          }

          .workspace-thumbnails {
            background-color: ${colors.bg1};
            border-radius: 8px;
            padding: 8px;
          }

          .workspace-thumbnail {
            border: 2px solid transparent;
            border-radius: 4px;
          }

          .workspace-thumbnail:hover {
            border-color: ${colors.bg3};
          }

          .workspace-thumbnail:active {
            border-color: ${colors.blue};
          }

          .window-clone {
            background-color: ${colors.bg1};
            border: 2px solid ${colors.bg2};
            border-radius: 8px;
          }

          .window-clone:hover {
            border-color: ${colors.blue};
          }

          .notification-banner {
            background-color: ${colors.bg1};
            color: ${colors.fg};
            border: 1px solid ${colors.bg2};
            border-radius: 8px;
            padding: 12px;
          }

          .notification-banner:hover {
            background-color: ${colors.bg2};
          }

          .message-list {
            background-color: ${colors.bg1};
            border-radius: 8px;
          }

          .message {
            background-color: ${colors.bg};
            border: 1px solid ${colors.bg2};
            border-radius: 6px;
            margin: 4px;
          }

          .message:hover {
            background-color: ${colors.bg2};
          }

          .quick-settings {
            background-color: ${colors.bg1};
            border-radius: 12px;
            padding: 12px;
          }

          .quick-settings-system-item {
            background-color: ${colors.bg};
            border-radius: 8px;
            padding: 8px;
          }

          .quick-settings-system-item:hover {
            background-color: ${colors.bg2};
          }

          .quick-toggle {
            background-color: ${colors.bg};
            border-radius: 8px;
            padding: 8px;
          }

          .quick-toggle:hover {
            background-color: ${colors.bg2};
          }

          .quick-toggle:checked {
            background-color: ${colors.blue};
            color: ${colors.bg};
          }

          .button {
            background-color: ${colors.bg2};
            color: ${colors.fg};
            border: 1px solid ${colors.bg3};
            border-radius: 6px;
            padding: 8px 16px;
          }

          .button:hover {
            background-color: ${colors.bg3};
            color: ${colors.fg_bright};
          }

          .button:active,
          .button:focus {
            background-color: ${colors.blue};
            color: ${colors.bg};
            border-color: ${colors.blue};
          }

          .modal-dialog {
            background-color: ${colors.bg1};
            color: ${colors.fg};
            border: 1px solid ${colors.bg2};
            border-radius: 12px;
            padding: 16px;
          }

          .modal-dialog-content-box {
            padding: 16px;
          }

          .popup-menu {
            background-color: ${colors.bg1};
            border: 1px solid ${colors.bg2};
            border-radius: 8px;
            padding: 4px;
          }

          .popup-menu-item {
            padding: 8px 12px;
            border-radius: 4px;
          }

          .popup-menu-item:hover {
            background-color: ${colors.bg2};
            color: ${colors.fg_bright};
          }

          .popup-menu-item:active {
            background-color: ${colors.blue};
            color: ${colors.bg};
          }

          .toggle-switch {
            background-color: ${colors.bg2};
            border-radius: 12px;
            width: 48px;
            height: 24px;
          }

          .toggle-switch:checked {
            background-color: ${colors.blue};
          }

          .slider {
            -barlevel-active-background-color: ${colors.blue};
            -barlevel-inactive-background-color: ${colors.bg2};
            -barlevel-overdrive-color: ${colors.red};
          }

          .osd-window {
            background-color: ${colors.bg1};
            border: 1px solid ${colors.bg2};
            border-radius: 12px;
            padding: 24px;
          }

          .osd-monitor-label {
            color: ${colors.fg};
          }

          .screenshot-ui-panel {
            background-color: ${colors.bg1};
            border-radius: 12px;
            padding: 12px;
          }

          .lg-dialog {
            background-color: ${colors.bg};
            color: ${colors.fg};
            border: 2px solid ${colors.bg2};
            border-radius: 8px;
          }

          .lg-completions-text {
            color: ${colors.fg_dim};
          }

          StScrollBar {
            padding: 0;
          }

          StScrollView.vfade {
            -st-vfade-offset: 32px;
          }

          StScrollView.hfade {
            -st-hfade-offset: 32px;
          }

          StScrollBar StButton#vhandle,
          StScrollBar StButton#hhandle {
            background-color: ${colors.bg3};
            border-radius: 8px;
          }

          StScrollBar StButton#vhandle:hover,
          StScrollBar StButton#hhandle:hover {
            background-color: ${colors.fg_dim};
          }

          .shell-link {
            color: ${colors.blue};
          }

          .shell-link:hover {
            color: ${colors.cyan};
          }
        '';

        gtkCss = optionalString hasColorScheme ''
          @define-color window_bg_color ${colors.bg};
          @define-color window_fg_color ${colors.fg};
          @define-color view_bg_color ${colors.bg};
          @define-color view_fg_color ${colors.fg};

          @define-color headerbar_bg_color ${colors.bg1};
          @define-color headerbar_fg_color ${colors.fg};
          @define-color headerbar_backdrop_color ${colors.bg};
          @define-color headerbar_shade_color ${colors.bg};

          @define-color card_bg_color ${colors.bg1};
          @define-color card_fg_color ${colors.fg};
          @define-color card_shade_color ${colors.bg};
          @define-color sidebar_bg_color ${colors.bg1};
          @define-color sidebar_fg_color ${colors.fg};
          @define-color sidebar_shade_color ${colors.bg};

          @define-color popover_bg_color ${colors.bg1};
          @define-color popover_fg_color ${colors.fg};

          @define-color dialog_bg_color ${colors.bg1};
          @define-color dialog_fg_color ${colors.fg};

          @define-color accent_bg_color ${colors.blue};
          @define-color accent_fg_color ${colors.bg};
          @define-color accent_color ${colors.blue};

          @define-color success_bg_color ${colors.green};
          @define-color success_fg_color ${colors.bg};
          @define-color success_color ${colors.green};

          @define-color warning_bg_color ${colors.yellow};
          @define-color warning_fg_color ${colors.bg};
          @define-color warning_color ${colors.yellow};

          @define-color error_bg_color ${colors.red};
          @define-color error_fg_color ${colors.bg};
          @define-color error_color ${colors.red};

          @define-color destructive_bg_color ${colors.red};
          @define-color destructive_fg_color ${colors.bg};
          @define-color destructive_color ${colors.red};

          @define-color borders ${colors.bg2};
          @define-color shade_color ${colors.bg};
          @define-color scrollbar_outline_color ${colors.bg};
        '';
      in
        mkMerge [
          {
            home.packages = with pkgs.gnomeExtensions; [
              just-perfection
              vitals
              pop-shell
              blur-my-shell
              user-themes
            ];

            dconf.settings = {
              "org/gnome/shell" = {
                disable-user-extensions = false;
                enabled-extensions = [
                  "just-perfection-desktop@just-perfection"
                  "pop-shell@system76.com"
                  "Vitals@CoreCoding.com"
                  "blur-my-shell@aunetx"
                  "user-theme@gnome-shell-extensions.gcampax.github.com"
                ];
              };

              "org/gnome/desktop/background" = mkIf (background != null && backgroundDark != null) {
                picture-uri = builtins.toString background;
                picture-uri-dark = builtins.toString backgroundDark;
              };

              "org/gnome/mutter" = {
                overlay-key = "Super_L";
                workspaces-only-on-primary = false;
              };

              "org/gnome/mutter/keybindings" = {
                toggle-tiled-left = ["@as []"];
                toggle-tiled-right = ["@as []"];
              };

              "org/gnome/shell/extensions/just-perfection" = {
                dash = false;
                workspace-switcher-should-show = true;
                workspace-popup = true;
                panel = true;
                activities-button = true;
                app-menu = false;
              };

              "org/gnome/shell/extensions/pop-shell" = {
                tile-by-default = true;
                active-hint = true;
                active-hint-border-radius = 4;
                smart-gaps = true;
                gap-inner = 4;
                gap-outer = 4;
                show-title = false;
                focus-left = ["<Super>Left"];
                focus-right = ["<Super>Right"];
                focus-up = ["<Super>Up"];
                focus-down = ["<Super>Down"];
                float-window-exceptions = [];
              };

              "org/gnome/shell/extensions/blur-my-shell/panel" = {
                blur = true;
                static-blur = true;
                unblur-in-overview = false;
                customize = true;
                override-background = true;
              };

              "org/gnome/desktop/wm/keybindings" = {
                switch-to-workspace-left = ["<Super><Control>Left"];
                switch-to-workspace-right = ["<Super><Control>Right"];
                switch-to-workspace-up = ["<Super><Control>Up"];
                switch-to-workspace-down = ["<Super><Control>Down"];
                close = ["<Super>q"];
                toggle-maximized = ["<Super>f"];
                maximize = ["@as []"];
                unmaximize = ["@as []"];
              };

              "org/gnome/shell/keybindings" = {
                focus-active-notification = ["@as []"];
                toggle-application-view = ["<Super>a"];
              };

              "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
                ];
              };

              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                name = "Open Ghostty Terminal";
                command = "ghostty";
                binding = "<Super>t";
              };

              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
                name = "Open Obsidian";
                command = "obsidian";
                binding = "<Super>n";
              };
            };

            gtk = {
              enable = true;
              gtk3.extraCss = gtkCss;
              gtk4 = {
                extraCss = gtkCss;
                theme = null;
              };

              theme = mkIf (!stylixManagesTheme) {
                name = "Adwaita-dark";
                package = pkgs.gnome-themes-extra;
              };

              iconTheme = mkIf (!stylixManagesTheme) {
                name = "Adwaita";
                package = pkgs.adwaita-icon-theme;
              };
            };
          }

          (mkIf hasColorScheme {
            home.file.".themes/NixColors/gnome-shell/gnome-shell.css".text = shellCss;

            dconf.settings = {
              "org/gnome/shell/extensions/user-theme" = {
                name = "NixColors";
              };
            };
          })

          (mkIf (!stylixManagesTheme) {
            dconf.settings = {
              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                gtk-theme = "Adwaita-dark";
              };
            };
          })
        ];
  };
}
