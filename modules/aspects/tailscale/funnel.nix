{
  den.aspects.tailscale-funnel = {
    name,
    port,
    httpsPort ? null,
    ...
  }: {
    name = "tailscale-funnel/${name}";
    nixos = {pkgs, ...}: {
      systemd.services."tailscale-funnel-${name}" = {
        description = "Tailscale Funnel for ${name}";
        after = ["tailscaled.service"];
        wants = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          until ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; do
            sleep 2
          done
          ${pkgs.tailscale}/bin/tailscale funnel --bg ${
            if httpsPort != null
            then "--https=${toString httpsPort} "
            else ""
          }${toString port}
        '';
        preStop = ''
          ${pkgs.tailscale}/bin/tailscale funnel --https=${toString (
            if httpsPort != null
            then httpsPort
            else 443
          )} off || true
        '';
      };
    };
  };
}
