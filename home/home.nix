{ inputs, user, pkgs, config, ... }:

{
  imports = [
    ./modules/cli
    ./modules/desktop
  ];

  home.username = user.name;
  home.homeDirectory = user.home;

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Enable if not using NixOS
  # targets.genericLinux.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  features = {
    cli = {
      # zsh.enable = false;
      # nushell.enable = false;
      # fish.enable = true;
      # fzf.enable = true;
      neofetch.enable = true;
    };
    desktop = {
      fonts.enable = true;
      # hyprland.enable = true;
      # wayland.enable = true;
      # xdg.enable = true;
    };
    # themes = {
      # gtk.enable = true;
      # qt.enable = true;
    # };
  };

  programs.home-manager.enable = true;
}
