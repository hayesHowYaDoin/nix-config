{
  den.aspects.tailscale-serve-vaultwarden.nixos = {pkgs, ...}: {
    systemd.services.tailscale-serve-vaultwarden = {
      description = "Tailscale Serve for Vaultwarden";
      after = ["tailscaled.service" "vaultwarden.service"];
      wants = ["tailscaled.service" "vaultwarden.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        until ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; do
          sleep 2
        done

        ${pkgs.tailscale}/bin/tailscale serve --bg --https 8222 http://localhost:8222
      '';

      preStop = ''
        ${pkgs.tailscale}/bin/tailscale serve --https 8222 off || true
      '';
    };
  };
}
