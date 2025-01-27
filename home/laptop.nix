{ inputs, user, pkgs, config, ... }:

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
      neofetch.enable = true;
      zsh.enable = true;
    };
    desktop = {
      fonts.enable = true;
      hyprland.enable = true;
      slippi.enable = false;
      vscode.enable = true;
      wayland = {
        enable = true;
        height = 30;
      };
      xdg.enable = true;
    };
  };

  home.packages = with pkgs; [
    acpi
  ];

  home = {
    username = user.name;
    homeDirectory = user.home;
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "vim";
      TERMINAL = "kitty";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      ELECTRON_EXTRA_FLAGS = "--force-device-scale-factor=1.5";
      #_JAVA_AWT_WM_NONREPARENTING = "1";
      #MOZ_DRM_DEVICE = "/dev/dri/card0:/dev/dri/card1";
      #WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
      #WLR_NO_HARDWARE_CURSORS = "1"; # if no cursor,uncomment this line
      #GBM_BACKEND = "nvidia-drm";
      #CLUTTER_BACKEND = "wayland";
      LIBVA_DRIVER_NAME = "iHD";
      #WLR_RENDERER = "vulkan";
      #VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
      #__NV_PRIME_RENDER_OFFLOAD = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      GTK_USE_PORTAL = "1";
      GTK_THEME = "Nightfox-dark";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_BIN_HOME = "${config.home.homeDirectory}/.nix-profile/bin";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  programs.home-manager.enable = true;
}
