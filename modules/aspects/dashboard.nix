{
  den.aspects.dashboard.nixos = {config, ...}: let
    host = config.networking.hostName;
  in {
    services.homepage-dashboard = {
      enable = true;
      listenPort = 3000;
      allowedHosts = "*";

      settings = {
        headerStyle = "boxed";
      };

      bookmarks = [];

      services = [
        {
          "Media" = [
            {
              "Audiobookshelf" = {
                description = "Audiobook & podcast server";
                href = "http://${host}:13378";
                icon = "audiobookshelf.png";
              };
            }
            {
              "Calibre" = {
                description = "Ebook library server";
                href = "http://${host}:8083";
                icon = "calibre.png";
              };
            }
            {
              "Immich" = {
                description = "Photo & video management";
                href = "http://${host}:2283";
                icon = "immich.png";
              };
            }
            {
              "Jellyfin" = {
                description = "Media streaming server";
                href = "http://${host}:8096";
                icon = "jellyfin.png";
              };
            }
            {
              "Jellyseerr" = {
                description = "Media request management";
                href = "http://${host}:5055";
                icon = "jellyseerr.png";
              };
            }
            {
              "RoMM" = {
                description = "ROM manager";
                href = "https://${host}.zeedonk-eagle.ts.net:9002";
                icon = "romm.png";
              };
            }
          ];
        }
        {
          "Arr!" = [
            {
              "Prowlarr" = {
                description = "Indexer manager";
                href = "http://${host}:9696";
                icon = "prowlarr.png";
              };
            }
            {
              "Radarr" = {
                description = "Movie manager";
                href = "http://${host}:7878";
                icon = "radarr.png";
              };
            }
            {
              "Sonarr" = {
                description = "TV show manager";
                href = "http://${host}:8989";
                icon = "sonarr.png";
              };
            }
            {
              "qBittorrent" = {
                description = "Torrent client";
                href = "http://${host}:8080";
                icon = "qbittorrent.png";
              };
            }
            {
              "Tdarr" = {
                description = "Media transcoding";
                href = "http://${host}:8265";
                icon = "tdarr.png";
              };
            }
          ];
        }
        {
          "Security" = [
            {
              "Uptime Kuma" = {
                description = "Uptime monitoring & status";
                href = "http://${host}:3001";
                icon = "uptime-kuma.png";
              };
            }
            {
              "Vaultwarden" = {
                description = "Password manager";
                href = "https://${host}.zeedonk-eagle.ts.net:8222";
                icon = "vaultwarden.png";
              };
            }
          ];
        }
        {
          "Home" = [
            {
              "Home Assistant" = {
                description = "Home automation platform";
                href = "http://${host}:8123";
                icon = "home-assistant.png";
              };
            }
            {
              "BudgetViz" = {
                description = "Budget visualization tool";
                href = "http://${host}:5173";
                icon = "si-lottiefiles";
              };
            }
            {
              "Mealie" = {
                description = "Recipe manager & meal planner";
                href = "http://${host}:9000";
                icon = "mealie.png";
              };
            }
          ];
        }
      ];

      widgets = [
        {
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
      ];

      customJS = "";
      customCSS = "";
    };
  };
}
