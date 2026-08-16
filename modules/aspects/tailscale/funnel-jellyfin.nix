{
  den.aspects.tailscale-funnel-jellyfin.nixos = {pkgs, ...}: {
    systemd.services.tailscale-funnel-jellyfin = {
      description = "Tailscale Funnel for Jellyfin";
      after = ["tailscaled.service" "jellyfin.service"];
      wants = ["tailscaled.service" "jellyfin.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        until ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; do
          sleep 2
        done

        ${pkgs.tailscale}/bin/tailscale funnel --bg 8096
      '';

      preStop = ''
        ${pkgs.tailscale}/bin/tailscale funnel --https=443 off || true
      '';
    };
  };
}
