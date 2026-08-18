{
  den.aspects.tdarr = {
    mediaDir,
    user ? "tdarr",
    dataDir ? "/var/lib/tdarr",
    cacheSize ? "8G",
    webPort ? 8265,
    serverPort ? 8266,
    gpu ? true,
    timezone ? "America/Denver",
    ...
  }: {
    name = "tdarr";
    nixos = {config, ...}: {
      users.users.${user} = {
        isSystemUser = true;
        group = user;
      };
      users.groups.${user} = {};

      systemd.services.podman-tdarr = {
        after = ["mnt-d.mount"];
        requires = ["mnt-d.mount"];
      };

      fileSystems."/var/cache/tdarr" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = ["size=${cacheSize}" "mode=1777"];
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.tdarr = {
          image = "ghcr.io/haveagitgat/tdarr:latest";
          autoStart = true;

          environment = {
            TZ = timezone;
            PUID = toString config.users.users.${user}.uid;
            PGID = toString config.users.groups.${user}.gid;
            serverIP = "0.0.0.0";
            serverPort = toString serverPort;
            webUIPort = toString webPort;
            internalNode = "true";
            inContainer = "true";
            ffmpegVersion = "7";
            nodeName = "internal";
          };

          ports = [
            "${toString webPort}:${toString webPort}"
            "${toString serverPort}:${toString serverPort}"
          ];

          volumes = [
            "${dataDir}/server:/app/server"
            "${dataDir}/configs:/app/configs"
            "${dataDir}/logs:/app/logs"
            "${mediaDir}:/media"
            "/var/cache/tdarr:/temp"
          ];

          extraOptions =
            if gpu
            then ["--device=nvidia.com/gpu=all"]
            else [];
        };
      };

      system.activationScripts."tdarr-setup-${user}" = {
        text = ''
          mkdir -p ${dataDir}/{server,configs,logs}
          chown -R ${user}:${user} ${dataDir}
          chmod -R 755 ${dataDir}
        '';
        deps = [];
      };

      networking.firewall.allowedTCPPorts = [webPort serverPort];
    };
  };
}
