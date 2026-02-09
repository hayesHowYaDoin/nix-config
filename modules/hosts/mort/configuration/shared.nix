{self, ...}: {
  flake.modules.nixos.mort-hardware = {
    imports = with self.modules.nixos; [
      default-editor
      default-shell
      nixpkgs-unfree
      tailscale
      tailscale-autoconnect
      tailscale-exit-node
      tailscale-ssh
      time
    ];

    services.tailscale.autoconnect.authKeyPath = "/run/secrets/tailscale_authkey";
  };
}
