{ pkgs, user, theme, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    fira-code
    droid-sans-mono
  ];

  fonts.fontconfig.enable = true;
}
