{
  den.aspects.tailscale-funnel-calibre.nixos = {pkgs, ...}: {
    systemd.services.tailscale-funnel-calibre = {
      description = "Tailscale Funnel for Calibre-Web";
      after = ["tailscaled.service" "calibre-web.service"];
      wants = ["tailscaled.service" "calibre-web.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        until ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; do
          sleep 2
        done

        ${pkgs.tailscale}/bin/tailscale funnel --bg --https=8443 8083
      '';

      preStop = ''
        ${pkgs.tailscale}/bin/tailscale funnel --https=8443 off || true
      '';
    };
  };
}
