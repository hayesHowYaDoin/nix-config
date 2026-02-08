{
  flake.modules.homeManager.nushell = {
    perSystem = {self', ...}: {
      home.packages = [self'.packages.nushell];
    };
  };
}
