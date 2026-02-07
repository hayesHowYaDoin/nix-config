{config, ...}: {
  colors =
    if config.stylix.enable or false
    then let
      inherit (config.lib.stylix) colors;
    in {
      primary = "#${colors.base0C}";
      secondary = "#${colors.base0D}";
      tertiary = "#${colors.base03}";
      success = "#${colors.base07}";
      error = "#${colors.base0D}";
    }
    else if config.colorScheme or null != null
    then let
      scheme = config.colorScheme;
    in {
      primary = "#${scheme.base0C}";
      secondary = "#${scheme.base0D}";
      tertiary = "#${scheme.base03}";
      success = "#${scheme.base07}";
      error = "#${scheme.base0D}";
    }
    else {
      primary = "#7daea3";
      secondary = "#7986CB";
      tertiary = "#9E9E9E";
      success = "#FFFFFF";
      error = "#7986CB";
    };
}
