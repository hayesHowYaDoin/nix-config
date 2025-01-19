{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./kitty.nix
    ./slippi.nix
    ./vscode.nix
    (import ./wayland.nix { height = 30; })
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    # Hyprland
    dbus
    sway-contrib.grimshot
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    hyprsunset
    rofi-wayland
    rofimoji
    qt6.qtwayland
    kdePackages.qt6ct
    slurp
    swappy
    waypipe
    wf-recorder
    wl-mirror
    wl-clipboard
    wlogout
    wtype
    wttrbar
    ydotool
    xdg-utils
    xwaylandvideobridge
    playerctl
    brightnessctl
    pamixer
    pavucontrol # Volume control
    jellyfin-ffmpeg # Multimedia libs
    viewnior # Image viewr
    mako # Notifications
    libcanberra-gtk3 # Notification sound
    libnotify # notify-send

    # Gnome utilities
    gtk-engine-murrine
    gnome-software
    gnome-disk-utility
    gnome-text-editor
    file-roller
    gnome-calculator
    nautilus # Gnome file manager
    gnome-system-monitor

    # Personal
    obsidian
    spotify
  ];
}