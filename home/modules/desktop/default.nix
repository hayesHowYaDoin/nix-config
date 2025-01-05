{ pkgs, ... }:

{
  imports = [
    # ./fonts.nix
    ./hyprland.nix
    ./kitty.nix
    ./obsidian.nix
    ./vscode.nix
    # ./waybar.nix
  ];
}