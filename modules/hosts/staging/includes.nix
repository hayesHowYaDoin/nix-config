{den, ...}: {
  den.aspects.staging.includes = with den.aspects; [
    tailscale
    tailscale-ssh
    vm-guest
    uptime-kuma
  ];
}
