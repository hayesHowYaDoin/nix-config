{
  den.aspects.tailscale-ssh.nixos = {
    services.tailscale.extraSetFlags = ["--ssh"];
  };
}
