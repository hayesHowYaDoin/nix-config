{hayes, ...}: {
  hayes.hyprland-desktop.includes = with hayes; [
    (hyprland-session {})
    waybar
    mako
    (fuzzel {})
    hyprlock
    (hypridle {})
    (hyprpaper {})
    wayland-utils
  ];
}
