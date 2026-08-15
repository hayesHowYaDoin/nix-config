{den, ...}: {
  den.aspects.staging.includes = [den.batteries.hostname];

  den.aspects.staging.nixos = {
    networking.useDHCP = true;
  };
}
