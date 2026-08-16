{
  den.aspects.qbittorrent.nixos = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.qbittorrent-nox
      pkgs.socat
    ];

    networking.firewall.allowedTCPPorts = [8080];

    system.activationScripts.qbittorrent-config = {
      text = ''
        mkdir -p /home/jordan/.config/qBittorrent
        chown jordan:users /home/jordan/.config/qBittorrent
        chmod 755 /home/jordan/.config/qBittorrent

        if [ ! -f /home/jordan/.config/qBittorrent/qBittorrent.conf ]; then
          cat > /home/jordan/.config/qBittorrent/qBittorrent.conf << 'EOF'
        [Preferences]
        WebUI\Address=0.0.0.0
        WebUI\Port=8080
        Downloads\SavePath=/home/jordan/Downloads
        General\UseRandomPort=false
        Connection\PortRangeMin=6881
        Advanced\RecheckOnCompletion=false
        BitTorrent\Session\DefaultSavePath=/home/jordan/Downloads
        EOF
          chown jordan:users /home/jordan/.config/qBittorrent/qBittorrent.conf
          chmod 600 /home/jordan/.config/qBittorrent/qBittorrent.conf
        fi
      '';
      deps = [];
    };

    systemd.services.qbittorrent-nox = {
      description = "qBittorrent-nox in VPN-isolated network namespace";
      after = ["vpn-netns-setup.service"];
      requires = ["vpn-netns-setup.service"];
      bindsTo = ["vpn-netns-setup.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.iproute2}/bin/ip netns exec vpn ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/bash jordan -c '${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8080'";
        Restart = "always";
        RestartSec = "10s";
        PrivateTmp = true;
      };
    };

    systemd.services.qbittorrent-port-forward = {
      description = "Forward qBittorrent web UI from VPN namespace to host";
      after = ["qbittorrent-nox.service"];
      requires = ["qbittorrent-nox.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "5s";
      };

      script = ''
        exec ${pkgs.socat}/bin/socat TCP-LISTEN:8080,fork,reuseaddr TCP:10.200.200.2:8080
      '';
    };
  };
}
