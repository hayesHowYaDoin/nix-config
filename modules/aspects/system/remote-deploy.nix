{
  hayes.remote-deploy.nixos = {
    services.openssh.enable = true;
    nix.settings.trusted-users = ["root" "@wheel"];

    # Passwordless sudo ONLY for colmena deploy
    security.sudo.extraRules = [
      {
        groups = ["wheel"];
        commands = [
          # Local `sudo nixos-rebuild` convenience.
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = ["NOPASSWD"];
          }
          # Colmena's two activation steps:
          #   sudo -H -- nix-env --profile /nix/var/nix/profiles/system --set <store-path>
          #   sudo -H -- <store-path>/bin/switch-to-configuration switch
          {
            command = "/run/current-system/sw/bin/nix-env";
            options = ["NOPASSWD"];
          }
          {
            command = "/nix/store/*/bin/switch-to-configuration";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
