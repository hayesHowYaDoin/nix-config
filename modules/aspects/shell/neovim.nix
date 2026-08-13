{
  den.aspects.neovim.homeManager = {self', ...}: {
    home.packages = [self'.packages.neovim];
  };
}
