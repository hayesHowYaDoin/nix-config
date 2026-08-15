{
  self,
  den,
  lib,
  ...
}: {
  den = {
    default = {
      nixos._module.args.self = self;
      nixos.nixpkgs.overlays = [self.overlays.default];
      homeManager.home.stateVersion = "25.11";
      includes = with den.aspects; [
        default-editor
        default-shell
        flakes
        remote-deploy
        time
        unfree
      ];
    };
    schema = {
      user.classes = lib.mkDefault ["homeManager"];
      # flake-system.includes = [den.aspects.flake];
    };
  };
}
