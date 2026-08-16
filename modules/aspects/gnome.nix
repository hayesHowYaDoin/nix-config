{
  den.aspects.gnome.nixos = {
    services = {
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        autoLogin = {
          enable = true;
          user = "jordan";
        };
        defaultSession = "gnome";
      };

      desktopManager.gnome.enable = true;

      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    };
  };
}
