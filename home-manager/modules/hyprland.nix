{ pkgs, lib, config, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &
  '';

    # sleep 1

    # ${pkgs.swww}/bin/swww img ${../assets/wallpaper.png} &
in {
  wayland.windowManager.hyprland = {
    # Allow home-manager to configure hyprland
    enable = true;

    settings = {
      exec-once = ''${startupScript}/bin/start'';

      bind = [
        # TODO: Configure keybindings
      ];
    };
  };
}