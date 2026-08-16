{
  den.aspects.tailscale-serve = {
    name,
    port,
    upstream ? "http://localhost:${toString port}",
    ...
  }: {
    name = "tailscale-serve/${name}";
    nixos = {pkgs, ...}: {
      systemd.services."tailscale-serve-${name}" = {
        description = "Tailscale Serve for ${name}";
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
          ${pkgs.tailscale}/bin/tailscale serve --bg --https ${toString port} ${upstream}
        '';
        preStop = ''
          ${pkgs.tailscale}/bin/tailscale serve --https ${toString port} off || true
        '';
      };
    };
  };
}
