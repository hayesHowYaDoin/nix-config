{
  den.aspects.zsh.homeManager = {self', ...}: {
    home.packages = [self'.packages.zsh];
  };
}
