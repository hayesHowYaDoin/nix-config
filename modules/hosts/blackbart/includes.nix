{hayes, ...}: {
  den.aspects.blackbart.includes = with hayes; [
    sops
    sleepless
    i18n
    tailscale
    tailscale-ssh
    (nordvpn {
      endpoint = "denver.us.wg.nordhold.net:51820";
      peerPublicKey = "mohrVW5iptcR0gt3Y/R8dcgmonn9ZAlsVwvxf60OdCM=";
    })
    vpn-killswitch
  ];
}
