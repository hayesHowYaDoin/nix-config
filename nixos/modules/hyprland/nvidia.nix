{ inputs, pkgs, ...}:

{
  # Enable Hyperland
  services.xserver.displayManager.gdm.wayland = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hind electron apps to use the wayland
    NIXOS_OZONE_WL = "1";
  };

  # hardware = {
  #   # Opengl
  #   graphics.enable = true;
  #   # Most wayland compositors need this
  #   nvidia.modesetting.enable = true;
  # };
}