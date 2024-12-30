{ inputs, pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   waybar
  #   libnotify
  #   mako
  #   swww
  #   rofi-wayland

  #   (waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags or [] ++ [ "-Dexperimental=true" ];
  #     })
  #   )
  # ];

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };
}