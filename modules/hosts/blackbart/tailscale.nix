{
  den.aspects.blackbart.nixos = {config, ...}: {
    sops.secrets.tailscale_authkey = {};
    services.tailscale.authKeyFile = config.sops.secrets.tailscale_authkey.path;
  };
}
