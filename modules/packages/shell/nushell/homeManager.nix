{
  flake.modules.homeManager.nushell = {self', ...}: {
    home.packages = [self'.packages.nushell];
  };
}
