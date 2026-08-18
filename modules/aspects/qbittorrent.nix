{den, ...}: {
  den.aspects.qbittorrent = {
    downloadsDir,
    user ? "qbittorrent",
    dataDir ? "/var/lib/qbittorrent",
    port ? 8080,
    ...
  }: {
    includes = [
      (den.aspects.vpn-namespaced {
        name = "qbittorrent-nox";
        inherit user port;
        execCommand = pkgs: "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString port} --profile=${dataDir}";
      })
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.qbittorrent-nox];

      networking.firewall.allowedTCPPorts = [port];

      users.users.${user} = {
        isSystemUser = true;
        group = user;
        home = dataDir;
        createHome = true;
      };
      users.groups.${user} = {};

      system.activationScripts."qbittorrent-${user}-config" = {
        text = ''
          mkdir -p ${dataDir}/qBittorrent/config
          if [ ! -f ${dataDir}/qBittorrent/config/qBittorrent.conf ]; then
            cat > ${dataDir}/qBittorrent/config/qBittorrent.conf << 'EOF'
          [Preferences]
          WebUI\Address=0.0.0.0
          WebUI\Port=${toString port}
          Downloads\SavePath=${downloadsDir}
          General\UseRandomPort=false
          Connection\PortRangeMin=6881
          Advanced\RecheckOnCompletion=false
          BitTorrent\Session\DefaultSavePath=${downloadsDir}
          EOF
          fi
          chown -R ${user}:${user} ${dataDir}
          chmod 600 ${dataDir}/qBittorrent/config/qBittorrent.conf
        '';
        deps = [];
      };
    };
  };
}
