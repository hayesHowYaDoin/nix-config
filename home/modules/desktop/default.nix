{ pkgs, ... }:

{
  imports = [
    ./ghostty.nix
    ./fonts.nix
    ./hyprland.nix
    ./kitty.nix
    ./slippi.nix
    ./vscode.nix
    ./wayland.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    obsidian
    spotify
    godot_4
    discord
    obs-studio
  ];
}
