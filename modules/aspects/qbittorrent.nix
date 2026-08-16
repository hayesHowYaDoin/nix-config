{
  den.aspects.qbittorrent = {den, ...}: {
    includes = [
      (den.aspects.vpn-namespaced {
        name = "qbittorrent-nox";
        port = 8080;
        execCommand = pkgs: "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8080";
      })
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.qbittorrent-nox];

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
    };
  };
}
