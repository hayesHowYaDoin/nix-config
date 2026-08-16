{
  # Needed for tailscale exit-node and vpn-namespace NAT.
  den.aspects.ip-forwarding.nixos = {
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };
}
