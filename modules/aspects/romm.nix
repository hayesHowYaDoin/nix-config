{
  den.aspects.romm.nixos = {config, ...}: let
    libraryPath = "/mnt/d/media/games";
    serviceDataPath = "/mnt/d/.services/romm";
    assetsPath = "${serviceDataPath}/assets";
    configPath = "${serviceDataPath}/config";
    igdbId = "kfehzsd55hmd6vpaoe5yu0qifn1yqt";

    mariadb = {
      name = "romm";
      user = "jordan";
    };

    screenscraper = {
      user = "Unsubtly0114";
    };
  in {
    sops.secrets = {
      mariadb_password = {
        owner = "root";
        mode = "0400";
      };
      mariadb_root_password = {
        owner = "root";
        mode = "0400";
      };
      screenscraper_password = {
        owner = "root";
        mode = "0400";
      };
      romm_auth_security_key = {
        owner = "root";
        mode = "0400";
      };
      retroachievements_api_key = {
        owner = "root";
        mode = "0400";
      };
      steamgriddb_api_key = {
        owner = "root";
        mode = "0400";
      };
      igdb_client_secret = {
        owner = "root";
        mode = "0400";
      };
    };

    sops.templates."romm.env" = {
      owner = "root";
      mode = "0400";
      content = ''
        DB_PASSWD=${config.sops.placeholder.mariadb_password}
        MARIADB_ROOT_PASSWORD=${config.sops.placeholder.mariadb_root_password}
        MARIADB_PASSWORD=${config.sops.placeholder.mariadb_password}
        ROMM_AUTH_SECRET_KEY=${config.sops.placeholder.romm_auth_security_key}
        RETROACHIEVEMENTS_API_KEY=${config.sops.placeholder.retroachievements_api_key}
        STEAMGRIDDB_API_KEY=${config.sops.placeholder.steamgriddb_api_key}
        IGDB_CLIENT_ID=${igdbId}
        IGDB_CLIENT_SECRET=${config.sops.placeholder.igdb_client_secret}
      '';
    };

    system.activationScripts.romm-setup = {
      text = ''
        if mountpoint -q /mnt/d; then
          mkdir -p ${assetsPath} ${configPath}
          chmod -R 755 ${serviceDataPath}
        fi
      '';
      deps = [];
    };

    systemd.services.podman-romm = {
      after = ["mnt-d.mount"];
      requires = ["mnt-d.mount"];
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers = {
        romm = {
          image = "rommapp/romm:latest";
          autoStart = true;

          environment = {
            DB_HOST = "romm-db";
            DB_NAME = mariadb.name;
            DB_USER = mariadb.user;
            SCREENSCRAPER_USER = screenscraper.user;
            HASHEOUS_API_ENABLED = "true";
          };

          environmentFiles = [config.sops.templates."romm.env".path];

          ports = [
            "127.0.0.1:9002:8080"
          ];

          volumes = [
            "romm_resources:/romm/resources"
            "romm_redis_data:/redis-data"
            "${libraryPath}:/romm/library"
            "${assetsPath}:/romm/assets"
            "${configPath}:/romm/config"
          ];
        };

        romm-db = {
          image = "mariadb:latest";
          autoStart = true;

          environment = {
            MARIADB_DATABASE = mariadb.name;
            MARIADB_USER = mariadb.user;
          };

          environmentFiles = [config.sops.templates."romm.env".path];

          volumes = [
            "mysql_data:/var/lib/mysql"
          ];

          extraOptions = [
            "--health-cmd=healthcheck.sh --connect --innodb_initialized"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
            "--health-start-period=30s"
            "--health-startup-interval=10s"
          ];
        };
      };
    };
  };
}
