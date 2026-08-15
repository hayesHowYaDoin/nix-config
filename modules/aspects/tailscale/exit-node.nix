{
  den.aspects.tailscale-exit-node.nixos = {
    services.tailscale.extraSetFlags = [
      "--advertise-exit-node"
      "--exit-node-allow-lan-access=true"
    ];
    networking.firewall.checkReversePath = "loose";
  };
}
