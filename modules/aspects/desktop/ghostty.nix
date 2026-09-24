{
  hayes.ghostty = {
    preinstalled ? false,
    nixGL ? false,
    opacity ? 1.0,
    shader ? null,
    windowDecoration ? false,
    ...
  }: {
    homeManager = {
      config,
      lib,
      pkgs,
      ...
    }: let
      wrappedGhostty = config.lib.nixGL.wrap pkgs.ghostty;
    in {
      programs.ghostty = {
        enable = true;
        package =
          if nixGL && !preinstalled
          then wrappedGhostty
          else if !preinstalled
          then pkgs.ghostty
          else null;
        systemd.enable = !preinstalled;
        settings =
          {
            window-decoration = windowDecoration;
            background-opacity = opacity;
          }
          // lib.optionalAttrs (config.colorScheme or null != null) {
            background = config.colorScheme.palette.base00;
            foreground = config.colorScheme.palette.base05;
            palette = [
              "0=${config.colorScheme.palette.base00}"
              "1=${config.colorScheme.palette.base08}"
              "2=${config.colorScheme.palette.base0B}"
              "3=${config.colorScheme.palette.base0A}"
              "4=${config.colorScheme.palette.base0D}"
              "5=${config.colorScheme.palette.base0E}"
              "6=${config.colorScheme.palette.base0C}"
              "7=${config.colorScheme.palette.base05}"
              "8=${config.colorScheme.palette.base03}"
              "9=${config.colorScheme.palette.base08}"
              "10=${config.colorScheme.palette.base0B}"
              "11=${config.colorScheme.palette.base0A}"
              "12=${config.colorScheme.palette.base0D}"
              "13=${config.colorScheme.palette.base0E}"
              "14=${config.colorScheme.palette.base0C}"
              "15=${config.colorScheme.palette.base07}"
            ];
          }
          // lib.optionalAttrs (shader != null) {
            custom-shader = builtins.toString shader;
            custom-shader-animation = "always";
          };
      };

      xdg.desktopEntries.ghostty = lib.mkIf nixGL {
        name = "Ghostty";
        genericName = "Terminal";
        exec = "${wrappedGhostty}/bin/ghostty";
        terminal = false;
        categories = ["System" "TerminalEmulator"];
        icon = "com.mitchellh.ghostty";
      };
    };
  };
}
