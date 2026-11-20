{
  hayes.qbittorrent = {
    downloadsDir,
    user ? "qbittorrent",
    dataDir ? "/var/lib/qbittorrent",
    port ? 8080,
    ...
  }: {
    name = "qbittorrent-svc/${user}";

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

      systemd.services.qbittorrent = {
        description = "qBittorrent-nox (${user})";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = user;
          Group = user;
          ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString port} --profile=${dataDir}";
          Restart = "on-failure";
          RestartSec = "10s";

          # Hardening. qBit is on the network, handles untrusted peer
          # input, and is the single most likely service on this host to
          # be RCE'd. Lock it down so a compromise can't walk off this box.
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK"];
          SystemCallArchitectures = "native";
          SystemCallFilter = ["@system-service" "~@privileged" "~@resources"];
          CapabilityBoundingSet = [];
          AmbientCapabilities = [];
          ReadWritePaths = [dataDir downloadsDir];
          UMask = "0077";
        };
      };

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
          mkdir -p ${downloadsDir}
          chown -R ${user}:${user} ${dataDir} ${downloadsDir}
          chmod 600 ${dataDir}/qBittorrent/config/qBittorrent.conf
        '';
        deps = [];
      };
    };
  };
}
