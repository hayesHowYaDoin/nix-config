{
  hayes.tailscale-ssh.nixos = {
    services.tailscale.extraSetFlags = ["--ssh"];
  };
}
