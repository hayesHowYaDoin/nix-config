{
  flake.modules.homeManager.neovim = {self', ...}: {
    home.packages = [self'.packages.neovim];
  };
}
