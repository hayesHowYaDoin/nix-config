{hayes, ...}: {
  den.aspects.blackbart.includes = with hayes; [
    sops
    i18n
    tailscale
    tailscale-ssh
    (openssh {passwordAuthentication = true;})
    # (nordvpn {})
    # vpn-killswitch
  ];
}
