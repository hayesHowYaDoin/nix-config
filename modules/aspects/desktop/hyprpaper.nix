{
  hayes.hyprpaper = {
    wallpaper ? null,
    ...
  }: {
    homeManager = {
      services.hyprpaper = {
        enable = true;
        settings =
          if wallpaper != null
          then {
            preload = [(toString wallpaper)];
            wallpaper = [",${toString wallpaper}"];
          }
          else {};
      };
    };
  };
}
