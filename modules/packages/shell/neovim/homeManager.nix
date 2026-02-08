{
  flake.modules.homeManager.neovim = {
    perSystem = {self', ...}: {
      home.packages = [self'.packages.neovim];
    };
  };
}
