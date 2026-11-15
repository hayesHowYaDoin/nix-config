{
  hayes.vpn-killswitch.nixos = {pkgs, ...}: {
    environment.systemPackages = [pkgs.nftables];

    # Route all DNS through Tailscale's MagicDNS at 100.100.100.100.
    # Allows for non-ISP resolver and prevents need to manually diagnose
    # changes in VPN domain.
    services.resolved.settings.Resolve = {
      DNS = ["100.100.100.100"];
      Domains = ["~."];
    };

    networking.nftables.enable = true;

    # cgroupv2 path matching can't be validated in the build sandbox (the
    # tailscaled.service cgroup doesn't exist until runtime).
    # Rules seem to load fine on the live system.
    networking.nftables.checkRuleset = false;

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
