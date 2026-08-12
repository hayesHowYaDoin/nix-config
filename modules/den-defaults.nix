{
  self,
  den,
  lib,
  ...
}: {
  den = {
    default = {
      nixos._module.args.self = self;
      homeManager._module.args.self = self;
      homeManager.home.stateVersion = "25.11";
      includes = [
        den.batteries.self'
        den.aspects.unfree
      ];
    };
    schema.user.classes = lib.mkDefault ["homeManager"];
  };
}
