{
  den.aspects.tailscale.nixos = {
    services.tailscale.enable = true;
    services.resolved.enable = true;

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [41641];
    };
  };
}
