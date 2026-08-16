{
  den.aspects.prowlarr.nixos = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.prowlarr
      pkgs.socat
    ];

    networking.firewall.allowedTCPPorts = [9696];

    system.activationScripts.prowlarr-config = {
      text = ''
        mkdir -p /home/jordan/.config/Prowlarr
        chown jordan:users /home/jordan/.config/Prowlarr
        chmod 755 /home/jordan/.config/Prowlarr
      '';
      deps = [];
    };

    # Prowlarr service running in VPN-isolated namespace
    systemd.services.prowlarr = {
      description = "Prowlarr in VPN-isolated network namespace";
      after = ["vpn-netns-setup.service"];
      requires = ["vpn-netns-setup.service"];
      bindsTo = ["vpn-netns-setup.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.iproute2}/bin/ip netns exec vpn ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/bash jordan -c '${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=/home/jordan/.config/Prowlarr'";
        Restart = "always";
        RestartSec = "10s";

        # Force .NET to use IPv4 only. The VPN namespace disables IPv6 via
        # sysctl, but getaddrinfo still returns AAAA records; .NET then tries
        # IPv6 first, gets EADDRNOTAVAIL, and surfaces it as "Unknown socket
        # error (0xFFFDFFFE)" instead of failing over to IPv4.
        Environment = "DOTNET_SYSTEM_NET_DISABLEIPV6=1";

        PrivateTmp = true;
      };
    };

    # Port forwarding service for web UI access
    systemd.services.prowlarr-port-forward = {
      description = "Forward Prowlarr web UI from VPN namespace to host";
      after = ["prowlarr.service"];
      requires = ["prowlarr.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "5s";
      };

      script = ''
        exec ${pkgs.socat}/bin/socat TCP-LISTEN:9696,fork,reuseaddr TCP:10.200.200.2:9696
      '';
    };
  };
}
