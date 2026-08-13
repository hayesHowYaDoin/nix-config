{
  den.aspects.nushell.homeManager = {self', ...}: {
    home.packages = [self'.packages.nushell];
  };
}
