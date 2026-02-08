{
  flake.homeModules.shell = {
    perSystem = {self', ...}: {
      home.packages = [self'.packages.nushell];
    };
  };
}
