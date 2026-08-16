{
  den.aspects.tailscale-serve-romm.nixos = {pkgs, ...}: {
    systemd.services.tailscale-serve-romm = {
      description = "Tailscale Serve for RoMM";
      after = ["tailscaled.service" "podman-romm.service"];
      wants = ["tailscaled.service" "podman-romm.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        until ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; do
          sleep 2
        done
        ${pkgs.tailscale}/bin/tailscale serve --bg --https 9002 http://localhost:9002
      '';

      preStop = ''
        ${pkgs.tailscale}/bin/tailscale serve --https 9002 off || true
      '';
    };
  };
}
