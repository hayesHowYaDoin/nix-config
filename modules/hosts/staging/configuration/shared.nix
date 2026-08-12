{den, ...}: {
  den.aspects.staging.includes = with den.aspects; [
    default-editor
    default-shell
    flakes
    time
    remote-deploy
    vm-guest
  ];
}
