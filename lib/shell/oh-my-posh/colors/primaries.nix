{config, ...}: {
  colors =
    if config.stylix.enable or false
    then let
      inherit (config.lib.stylix) colors;
    in {
      primary = "#${colors.base08}";
      secondary = "#${colors.base0D}";
      tertiary = "#${colors.base03}";
      success = "#${colors.base0A}";
      error = "#${colors.base08}";
    }
    else if config.colorScheme or null != null
    then let
      scheme = config.colorScheme;
    in {
      primary = "#${scheme.palette.base08}"; # red
      secondary = "#${scheme.palette.base0D}"; # blue
      tertiary = "#${scheme.palette.base03}"; # bright black
      success = "#${scheme.palette.base0A}"; # yellow
      error = "#${scheme.palette.base08}"; # red
    }
    else {
      primary = "#ed8274";
      secondary = "#7daea3";
      tertiary = "#6C6C6C";
      success = "#d8a657";
      error = "#ed8274";
    };
}
