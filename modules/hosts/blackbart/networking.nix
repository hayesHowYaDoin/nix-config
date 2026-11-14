{den, ...}: {
  den.aspects.blackbart.includes = [den.batteries.hostname];

  den.aspects.blackbart.nixos = {
    networking.useDHCP = true;
  };

  # Pin DHCP to eno1 only. Commented for the first remote deploy — the
  # above `useDHCP = true` keeps all interfaces up so SSH doesn't drop.
  # Uncomment (and remove the block above) once the host has been
  # deployed and verified.
  #den.aspects.blackbart.nixos = {
  #  networking = {
  #    useDHCP = false;
  #    interfaces.eno1.useDHCP = true;
  #  };
  #};
}
