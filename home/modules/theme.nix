{ inputs, pkgs, user, theme, ... }:

let
  palette = inputs.nix-colors.colorSchemes.material-darker.colors;

  theme = {
    colorScheme = {
      transparencyBackgroundHex = "CC";
      transparencyForegroundHex = "EE";
      transparencyHeavyShadeHex = "5C";
      transparencyLightShadeHex = "14";

      transparencyBackgroundRGB = "0.8";
      transparencyForegroundRGB = "0.93";
      transparencyHeavyShadeRGB = "0.36";
      transparencyLightShadeRGB = "0.08";

      background1Hex = palette.base00;
      background2Hex = palette.base01;
      background3Hex = palette.base02;
      background4Hex = palette.base03;
      foreground4Hex = palette.base04;
      foreground3Hex = palette.base05;
      foreground2Hex = palette.base06;
      foreground1Hex = palette.base07;

      background1RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base00;
      background2RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base01;
      background3RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base02;
      background4RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base03;
      foreground4RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base04;
      foreground3RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base05;
      foreground2RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base06;
      foreground1RGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base07;
  
      redHex = palette.base08;
      orangeHex = palette.base09;
      yellowHex = palette.base0A;
      greenHex = palette.base0B;
      cyanHex = palette.base0C;
      blueHex = palette.base0D;
      magentaHex = palette.base0E;
      brownHex = palette.base0F;
  
      redRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base08;
      orangeRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base09;
      yellowRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base0A;
      greenRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base0B;
      cyanRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base0C;
      blueRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base0D;
      magentaRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base0E;
      brownRGB = inputs.nix-colors.lib.conversions.hexToRGBString "," palette.base0F;
  
      accentHex = theme.colorScheme.cyanHex;
      secondaryAccentHex = theme.colorScheme.greenHex;
      dangerHex = theme.colorScheme.redHex;
      warningHex = theme.colorScheme.yellowHex;
      infoHex = theme.colorScheme.blueHex;
      successHex = theme.colorScheme.greenHex;
      specialHex = theme.colorScheme.magentaHex;
      
      accentRGB = theme.colorScheme.cyanRGB;
      secondaryAccentRGB = theme.colorScheme.greenRGB;
      dangerRGB = theme.colorScheme.redRGB;
      warningRGB = theme.colorScheme.yellowRGB;
      infoRGB = theme.colorScheme.blueRGB;
      successRGB = theme.colorScheme.greenRGB;
      specialRGB = theme.colorScheme.magentaRGB;
  
      newtForeground = "white";
      newtBackground = "black";
      newtAccent = "cyan";
    };

    borderWidth = 1;
    borderRadius = 5;
    gapsIn = 3;
    gapsOut = 5;

    fontPackage = pkgs.noto-fonts;
    fontName = "Noto Sans";
    fontSize = 11;
    fontSizeUI = 16;
    monoFontPackage = pkgs.noto-fonts;
    monoFontName = "Noto Sans Mono";
    monoFontSize = 10;

    cursorThemePackage = pkgs.gnome.adwaita-icon-theme;
    cursorThemeName = "Adwaita";
    cursorSize = 40;
    
    iconThemePackage = pkgs.flat-remix-icon-theme;
    iconThemeName = "Flat-Remix-Cyan-Dark";

    themePackage = pkgs.adw-gtk3;
    themeName = "adw-gtk3-dark";
    qtPlatformTheme = "gtk";
    qtStyleName = "adwaita-dark";
  };

  gtkCss = ''
    @define-color accent_color #${theme.colorScheme.blueHex};
    @define-color accent_bg_color #${theme.colorScheme.blueHex};
    @define-color accent_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color destructive_color #${theme.colorScheme.redHex};
    @define-color destructive_bg_color #${theme.colorScheme.redHex};
    @define-color destructive_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color success_color #${theme.colorScheme.greenHex};
    @define-color success_bg_color #${theme.colorScheme.greenHex};
    @define-color success_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color warning_color #${theme.colorScheme.yellowHex};
    @define-color warning_bg_color #${theme.colorScheme.yellowHex};
    @define-color warning_fg_color rgba(${theme.colorScheme.background1RGB},${theme.colorScheme.transparencyBackgroundRGB});
    @define-color error_color #${theme.colorScheme.redHex};
    @define-color error_bg_color #${theme.colorScheme.redHex};
    @define-color error_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color window_bg_color #${theme.colorScheme.background2Hex};
    @define-color window_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color view_bg_color #${theme.colorScheme.background1Hex};
    @define-color view_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color headerbar_bg_color #${theme.colorScheme.background2Hex};
    @define-color headerbar_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color headerbar_border_color #${theme.colorScheme.foreground1Hex};
    @define-color headerbar_backdrop_color #${theme.colorScheme.background2Hex};
    @define-color headerbar_shade_color rgba(${theme.colorScheme.background1RGB},${theme.colorScheme.transparencyHeavyShadeRGB});
    @define-color card_bg_color rgba(${theme.colorScheme.foreground1RGB},${theme.colorScheme.transparencyLightShadeRGB});
    @define-color card_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color card_shade_color rgba(${theme.colorScheme.background1RGB},${theme.colorScheme.transparencyHeavyShadeRGB});
    @define-color dialog_bg_color #${theme.colorScheme.background3Hex};
    @define-color dialog_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color popover_bg_color #${theme.colorScheme.background3Hex};
    @define-color popover_fg_color #${theme.colorScheme.foreground1Hex};
    @define-color shade_color rgba(${theme.colorScheme.background1RGB},${theme.colorScheme.transparencyHeavyShadeRGB});
    @define-color scrollbar_outline_color rgba(${theme.colorScheme.background1RGB},${theme.colorScheme.transparencyHeavyShadeRGB});
    @define-color blue_1 #${theme.colorScheme.blueHex};
    @define-color blue_2 #${theme.colorScheme.blueHex};
    @define-color blue_3 #${theme.colorScheme.blueHex};
    @define-color blue_4 #${theme.colorScheme.blueHex};
    @define-color blue_5 #${theme.colorScheme.blueHex};
    @define-color green_1 #${theme.colorScheme.greenHex};
    @define-color green_2 #${theme.colorScheme.greenHex};
    @define-color green_3 #${theme.colorScheme.greenHex};
    @define-color green_4 #${theme.colorScheme.greenHex};
    @define-color green_5 #${theme.colorScheme.greenHex};
    @define-color yellow_1 #${theme.colorScheme.yellowHex};
    @define-color yellow_2 #${theme.colorScheme.yellowHex};
    @define-color yellow_3 #${theme.colorScheme.yellowHex};
    @define-color yellow_4 #${theme.colorScheme.yellowHex};
    @define-color yellow_5 #${theme.colorScheme.yellowHex};
    @define-color orange_1 #${theme.colorScheme.orangeHex};
    @define-color orange_2 #${theme.colorScheme.orangeHex};
    @define-color orange_3 #${theme.colorScheme.orangeHex};
    @define-color orange_4 #${theme.colorScheme.orangeHex};
    @define-color orange_5 #${theme.colorScheme.orangeHex};
    @define-color red_1 #${theme.colorScheme.redHex};
    @define-color red_2 #${theme.colorScheme.redHex};
    @define-color red_3 #${theme.colorScheme.redHex};
    @define-color red_4 #${theme.colorScheme.redHex};
    @define-color red_5 #${theme.colorScheme.redHex};
    @define-color purple_1 #${theme.colorScheme.magentaHex};
    @define-color purple_2 #${theme.colorScheme.magentaHex};
    @define-color purple_3 #${theme.colorScheme.magentaHex};
    @define-color purple_4 #${theme.colorScheme.magentaHex};
    @define-color purple_5 #${theme.colorScheme.magentaHex};
    @define-color brown_1 #${theme.colorScheme.brownHex};
    @define-color brown_2 #${theme.colorScheme.brownHex};
    @define-color brown_3 #${theme.colorScheme.brownHex};
    @define-color brown_4 #${theme.colorScheme.brownHex};
    @define-color brown_5 #${theme.colorScheme.brownHex};
    @define-color light_1 #${theme.colorScheme.foreground1Hex};
    @define-color light_2 #${theme.colorScheme.foreground1Hex};
    @define-color light_3 #${theme.colorScheme.foreground2Hex};
    @define-color light_4 #${theme.colorScheme.foreground3Hex};
    @define-color light_5 #${theme.colorScheme.foreground4Hex};
    @define-color dark_1 #${theme.colorScheme.background4Hex};
    @define-color dark_2 #${theme.colorScheme.background3Hex};
    @define-color dark_3 #${theme.colorScheme.background2Hex};
    @define-color dark_4 #${theme.colorScheme.background1Hex};
    @define-color dark_5 #${theme.colorScheme.background1Hex};
  '';
in
{
  home.file = {
    ".config/gtk-3.0/gtk.css".text = gtkCss;
    ".config/gtk-4.0/gtk.css".text = gtkCss;
  };
  home.pointerCursor = {
    package = theme.cursorThemePackage;
    name = theme.cursorThemeName;
    size = theme.cursorSize;
    gtk.enable = true;
    x11 = {
      enable = true;
      defaultCursor = "left_ptr";
    };
  };

  fonts.fontconfig.enable = true;
  
  gtk = {
    enable = true;
    font = {
      package = theme.fontPackage;
      name = theme.fontName;
      size = theme.fontSize;
    };
    theme.package = theme.themePackage;
    theme.name = theme.themeName;
    iconTheme.package = theme.iconThemePackage;
    iconTheme.name = theme.iconThemeName;
    gtk3.bookmarks = [
      "file://${user.home}/Documents Documents"
      "file://${user.home}/Downloads Downloads"
      "file://${user.home}/Music Music"
      "file://${user.home}/Pictures Pictures"
      "file://${user.home}/Templates Templates"
      "file://${user.home}/Videos Videos"
    ];
  };

  qt = {
    enable = true;
    platformTheme = theme.qtPlatformTheme;
    style.name = theme.qtStyleName;
  };
}