{den, ...}: {
  den.aspects.staging.includes = with den.aspects; [
    vm-guest
  ];
}
