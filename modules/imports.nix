{inputs, ...}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
    inputs.den.flakeModule
    # inputs.den.flakeModules.strict
    # inputs.den.flakeOutputs.packages
  ];
}
