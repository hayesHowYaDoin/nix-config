{
  # Static NordVPN WireGuard tunnel using the manual config NordVPN exposes
  # in the account dashboard.
  #
  # Uses networking.wg-quick (not networking.wireguard) because wg-quick does
  # the fwmark + policy-routing trick needed for AllowedIPs = 0.0.0.0/0 to
  # work without a routing loop. The plain wireguard module just adds
  # `default dev wgnord` naively, which breaks return traffic.
  hayes.nordvpn = {
    endpoint,
    peerPublicKey,
    address ? "10.5.0.2/16",
    ...
  }: {
    nixos = {config, ...}: {
      sops.secrets.wgnord_privkey = {
        owner = "root";
        mode = "0400";
      };

      networking.wg-quick.interfaces.wgnord = {
        privateKeyFile = config.sops.secrets.wgnord_privkey.path;
        address = [address];
        peers = [
          {
            publicKey = peerPublicKey;
            inherit endpoint;
            allowedIPs = ["0.0.0.0/0" "::/0"];
            persistentKeepalive = 25;
          }
        ];
      };

      # Depends on tailscale for MagicDNS
      systemd.services.wg-quick-wgnord = {
        after = ["tailscaled.service"];
        requires = ["tailscaled.service"];
        serviceConfig.Restart = "on-failure";
        serviceConfig.RestartSec = "10s";
        unitConfig.StartLimitIntervalSec = 0;
      };
    };
  };
}
