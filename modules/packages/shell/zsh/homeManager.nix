{
  flake.modules.homeManager.zsh = {
    perSystem = {self', ...}: {
      home.packages = [self'.packages.zsh];
    };
  };
}
