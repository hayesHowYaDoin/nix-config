{
  hayes.hyprland.nixos = {pkgs, ...}: {
    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
  };
}
