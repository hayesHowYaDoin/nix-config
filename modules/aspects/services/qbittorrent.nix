{
  hayes.qbittorrent = {
    downloadsDir,
    user ? "qbittorrent",
    dataDir ? "/var/lib/qbittorrent",
    port ? 8080,
    incompleteDir ? null,
    ...
  }: {
    name = "qbittorrent-svc/${user}";

    nixos = {
      pkgs,
      lib,
      ...
    }: {
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
          ReadWritePaths = [dataDir downloadsDir] ++ lib.optional (incompleteDir != null) incompleteDir;
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
          ${lib.optionalString (incompleteDir != null) ''
            Downloads\TempPathEnabled=true
            Downloads\TempPath=${incompleteDir}
          ''}General\UseRandomPort=false
          Connection\PortRangeMin=6881
          Advanced\RecheckOnCompletion=false
          BitTorrent\Session\DefaultSavePath=${downloadsDir}
          ${lib.optionalString (incompleteDir != null) ''
            BitTorrent\Session\TempPathEnabled=true
            BitTorrent\Session\TempPath=${incompleteDir}
          ''}EOF
          fi
          mkdir -p ${downloadsDir}
          ${lib.optionalString (incompleteDir != null) "mkdir -p ${incompleteDir}"}
          chown -R ${user}:${user} ${dataDir} ${downloadsDir} ${lib.optionalString (incompleteDir != null) incompleteDir}
          chmod 600 ${dataDir}/qBittorrent/config/qBittorrent.conf
        '';
        deps = [];
      };
    };
  };
}
