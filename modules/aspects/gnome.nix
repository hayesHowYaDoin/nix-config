{
  den.aspects.gnome = {
    autoLoginUser ? null,
    keyboardLayout ? "us",
    keyboardVariant ? "",
    wayland ? true,
    ...
  }: {
    name = "gnome";
    nixos = {
      services = {
        displayManager = {
          gdm = {
            enable = true;
            inherit wayland;
          };
          autoLogin =
            if autoLoginUser != null
            then {
              enable = true;
              user = autoLoginUser;
            }
            else {enable = false;};
          defaultSession = "gnome";
        };

        desktopManager.gnome.enable = true;

        xserver = {
          enable = true;
          xkb = {
            layout = keyboardLayout;
            variant = keyboardVariant;
          };
        };
      };
    };
  };
}
