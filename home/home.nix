{ inputs, user, pkgs, config, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/obsidian.nix
    ./modules/vscode.nix
    ./modules/hyprland.nix
    ./modules/containers.nix
  ];

  home.username = user.name;
  home.homeDirectory = user.home;

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Enable if not using NixOS
  # targets.genericLinux.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
