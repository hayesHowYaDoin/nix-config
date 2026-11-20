{hayes, ...}: {
  hayes.ntfy = {
    port ? 8585,
    domain ? null,
    ...
  }: {
    includes = [
      (hayes.tailscale-serve {
        name = "ntfy";
        inherit port;
      })
    ];

    nixos = {config, ...}: {
      services.ntfy-sh = {
        enable = true;
        settings = {
          base-url =
            if domain != null
            then domain
            else "https://${config.networking.hostName}.zeedonk-eagle.ts.net";
          listen-http = "127.0.0.1:${toString port}";
          behind-proxy = true;
          # No Firebase / UP relay. Mobile clients subscribe over the
          # tailnet via the Tailscale app — no third-party push path.
        };
      };

      networking.firewall.allowedTCPPorts = [port];
    };
  };
}
