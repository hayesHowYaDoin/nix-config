{ inputs, user, pkgs, config, lib, system, ... }:

{
  imports = [
    ./modules/cli
    ./modules/desktop
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./assets/wallpaper.jpeg;
  };

  # Enable if not using NixOS
  # targets.genericLinux.enable = true;

  features = {
    cli = {
      neofetch.enable = false;
      zsh.enable = true;
    };
    desktop = {
      ghostty.enable = true;
      fonts.enable = true;
      hyprland.enable = false;
      slippi.enable = false;
      vscode.enable = true;
      wayland.enable = false;
      xdg.enable = true;
    };
  };

  home = {
    username = user.name;
    homeDirectory = user.home;
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  # Stylix can't replace this file and doing so has no obvious concequence
  home.activation.removeBackups = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ${config.home.homeDirectory}/.gtkrc-2.0.backup
  '';

  programs.home-manager.enable = true;
}
