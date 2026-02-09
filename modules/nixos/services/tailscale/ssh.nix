{
  flake.modules.nixos.tailscale-ssh = {
    services.tailscale.extraSetFlags = ["--ssh"];
  };
}
