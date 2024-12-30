{ pkgs, user, theme, ... }:

{
  home.packages = with pkgs; [
    obsidian
  ];
}
