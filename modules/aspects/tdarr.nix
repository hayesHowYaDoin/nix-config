{
  den.aspects.tdarr.nixos = let
    dataDir = "/mnt/d/.services/tdarr";
    # jordan's uid — set to 1000 by default via primary-user; hardcode here
    uid = "1000";
    gid = "100"; # users group
  in {
    systemd.services.podman-tdarr = {
      after = ["mnt-d.mount"];
      requires = ["mnt-d.mount"];
    };

    fileSystems."/var/cache/tdarr" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=8G" "mode=1777"];
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.tdarr = {
        image = "ghcr.io/haveagitgat/tdarr:latest";
        autoStart = true;

        environment = {
          TZ = "America/Denver";
          PUID = uid;
          PGID = gid;
          serverIP = "0.0.0.0";
          serverPort = "8266";
          webUIPort = "8265";
          internalNode = "true";
          inContainer = "true";
          ffmpegVersion = "7";
          nodeName = "internal";
        };

        ports = [
          "8265:8265"
          "8266:8266"
        ];

        volumes = [
          "${dataDir}/server:/app/server"
          "${dataDir}/configs:/app/configs"
          "${dataDir}/logs:/app/logs"
          "/mnt/d/media:/media"
          "/var/cache/tdarr:/temp"
        ];

        # GPU passthrough via CDI
        extraOptions = [
          "--device=nvidia.com/gpu=all"
        ];
      };
    };

    system.activationScripts.tdarr-setup = {
      text = ''
        if mountpoint -q /mnt/d; then
          mkdir -p ${dataDir}/{server,configs,logs}
          chown -R ${uid}:${gid} ${dataDir}
          chmod -R 755 ${dataDir}
        fi
      '';
      deps = [];
    };

    networking.firewall.allowedTCPPorts = [8265 8266];
  };
}
