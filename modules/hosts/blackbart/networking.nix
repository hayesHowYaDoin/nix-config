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
  };
}
