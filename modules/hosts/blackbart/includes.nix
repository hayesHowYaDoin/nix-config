{hayes, ...}: {
  den.aspects.blackbart.includes = with hayes; [
    sops
    i18n
    tailscale
    tailscale-ssh
    # (nordvpn {})
    # vpn-killswitch
  ];
}
