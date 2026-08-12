{
  flake.modules.homeManager.zsh = {self', ...}: {
    home.packages = [self'.packages.zsh];
  };
}
