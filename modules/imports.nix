{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
    inputs.den.flakeModule
    #inputs.den.flakeModules.strict
  ];
}
