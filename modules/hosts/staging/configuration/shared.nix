{
  den,
  self,
  ...
}: {
  den.aspects.staging.includes = with den.aspects; [
    flakes
    remote-deploy
    vm-guest
  ];

  den.aspects.staging.nixos = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
      time
    ];
  };
}
