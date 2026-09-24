{
  hayes.wayland-utils.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      wl-clipboard
      grim
      slurp
      brightnessctl
      hyprpicker
      hyprshot
      hyprsunset
      playerctl
      libnotify
    ];
  };
}
