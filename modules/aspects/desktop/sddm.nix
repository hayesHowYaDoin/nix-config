{
  hayes.sddm = {
    autoLoginUser ? null,
    defaultSession ? "hyprland",
    ...
  }: {
    nixos = {
      services.displayManager = {
        inherit defaultSession;
        sddm = {
          enable = true;
          wayland.enable = true;
        };
        autoLogin =
          if autoLoginUser != null
          then {
            enable = true;
            user = autoLoginUser;
          }
          else {enable = false;};
      };
    };
  };
}
