{
  den,
  hayes,
  ...
}: {
  den.aspects.blackbart.includes = [
    den.batteries.hostname
    hayes.tailscale
    hayes.tailscale-ssh
    hayes.openssh
    (hayes.nordvpn {
      endpoint = "denver.us.wg.nordhold.net:51820";
      peerPublicKey = "mohrVW5iptcR0gt3Y/R8dcgmonn9ZAlsVwvxf60OdCM=";
    })
    hayes.sops
    hayes.vpn-killswitch
  ];

  den.aspects.blackbart.nixos = {config, ...}: {
    networking.useDHCP = true;

    services.openssh.openFirewall = false;

    sops.secrets.tailscale_authkey = {};
    services.tailscale.authKeyFile = config.sops.secrets.tailscale_authkey.path;

    # wg-quick's default-route trick installs an ip rule at priority 5209
    # that intercepts all unmarked packets and sends them through wgnord.
    # Tailscale's rule for the 100.64.0.0/10 CGNAT range is at priority
    # 5270 — fires too late. Reply traffic to tailnet peers gets encrypted
    # toward Nord and dropped. Carve out the tailnet range at a priority
    # before wg-quick's so it reaches Tailscale's routing table.
    networking.wg-quick.interfaces.wgnord.postUp = ''
      ip -4 rule add to 100.64.0.0/10 lookup 52 priority 5200 || true
    '';
    networking.wg-quick.interfaces.wgnord.preDown = ''
      ip -4 rule del to 100.64.0.0/10 lookup 52 priority 5200 || true
    '';
  };
}
