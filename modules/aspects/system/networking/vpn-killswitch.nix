{
  hayes.vpn-killswitch.nixos = {
    networking.nftables.enable = true;

    networking.nftables.tables.killswitch = {
      family = "inet";
      content = ''
        chain output {
          type filter hook output priority filter; policy drop;

          oifname "lo" accept
          oifname "wgnord" accept
          oifname "tailscale0" accept

          meta l4proto udp udp dport 51820 accept

          socket cgroupv2 level 2 "system.slice/tailscaled.service" accept

          udp sport 68 udp dport 67 accept
        }
      '';
    };
  };
}
