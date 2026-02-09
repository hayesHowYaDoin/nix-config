{
  flake.modules.nixos.tailscale-autoconnect = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.tailscale.autoconnect;
  in {
    options.services.tailscale.autoconnect = {
      authKeyPath = lib.mkOption {
        type = lib.types.path;
        description = "Path to the Tailscale auth key file";
      };
    };

    config = {
      systemd.services.tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";
        after = ["network-pre.target" "tailscaled.service"];
        wants = ["network-pre.target" "tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig.Type = "oneshot";
        script = ''
          sleep 2
          status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
          if [ "$status" = "Running" ]; then
            exit 0
          fi
          ${pkgs.tailscale}/bin/tailscale up --authkey file:${cfg.authKeyPath}
        '';
      };
    };
  };
}
