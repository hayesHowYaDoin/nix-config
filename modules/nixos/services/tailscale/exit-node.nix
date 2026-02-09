{
  flake.modules.nixos.tailscale-exit-node = {
    services.tailscale.extraSetFlags = [
      "--advertise-exit-node"
      "--exit-node-allow-lan-access=true"
    ];
    networking.firewall.checkReversePath = "loose";
  };
}
