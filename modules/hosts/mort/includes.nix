{hayes, ...}: {
  den.aspects.mort.includes = with hayes; [
    sops
    network-manager
    tailscale
    tailscale-ssh
    tailscale-exit-node
    ip-forwarding
  ];
}
