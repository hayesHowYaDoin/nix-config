{ pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./../../home/assets/wallpaper.jpeg;
    targets.gtk.enable = true;
  };
}
