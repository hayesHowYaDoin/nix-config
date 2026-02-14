{self, ...}: {
  flake.modules.nixos.mort-configuration = {config, ...}: {
    imports = with self.modules.nixos; [
      sops
      tailscale
      tailscale-ssh
    ];

    sops.secrets.tailscale_authkey = {};

    services.tailscale.authKeyFile = config.sops.secrets.tailscale_authkey.path;
  };
}
