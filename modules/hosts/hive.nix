{
  self,
  inputs,
  ...
}: {
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta = {
      nixpkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      specialArgs = {inherit self inputs;};
    };

    staging = {
      imports = self.nixosConfigurations.staging._module.args.modules or [];
      deployment.targetHost = "192.168.122.143";
      deployment.targetUser = "jordan";
    };
  };
}
