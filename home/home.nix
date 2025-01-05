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

  programs.home-manager.enable = true;
}
