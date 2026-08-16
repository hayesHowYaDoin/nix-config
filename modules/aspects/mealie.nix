{
  den.aspects.mealie.nixos = {
    pkgs,
    config,
    ...
  }: let
    mealie-addons = pkgs.fetchurl {
      url = "https://github.com/razziel89/mealie-addons/releases/download/0.7.0/mealie-addons_0.7.0_linux_amd64.tar.gz";
      sha256 = "sha256-fqrX5fYrzpYzB7/6OpWoUgwKXYQj2onmZV0PmSb+iNg=";
    };

    mealie-addons-extracted = pkgs.runCommand "mealie-addons" {} ''
      mkdir -p $out/bin
      tar -xzf ${mealie-addons} -C $out/bin
      chmod +x $out/bin/mealie-addons
    '';
  in {
    sops.secrets.mealie_token = {
      owner = "root";
      mode = "0400";
    };

    services.mealie = {
      enable = true;
      port = 9000;
    };

    networking.firewall.allowedTCPPorts = [9000];

    system.activationScripts.mealie-backup-setup = {
      text = ''
        mkdir -p /mnt/d/documents/recipes/mealie-exports
        chmod 755 /mnt/d/documents/recipes/mealie-exports
      '';
      deps = [];
    };

    environment.etc."mealie/export-recipes.sh" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        EXPORT_DIR="/mnt/d/documents/recipes/mealie-exports"
        TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y%m%d_%H%M%S)
        EXPORT_FILE="$EXPORT_DIR/recipes_$TIMESTAMP.md"
        LATEST_LINK="$EXPORT_DIR/recipes_latest.md"

        ${pkgs.curl}/bin/curl -s "http://localhost:9001/book/markdown?orderBy=name&orderDirection=asc" > "$EXPORT_FILE"
        ${pkgs.coreutils}/bin/ln -sf "$EXPORT_FILE" "$LATEST_LINK"

        cd "$EXPORT_DIR"
        ${pkgs.coreutils}/bin/ls -t recipes_*.md | ${pkgs.coreutils}/bin/tail -n +31 | ${pkgs.findutils}/bin/xargs -r rm

        echo "Exported recipes to $EXPORT_FILE"
      '';
      mode = "0755";
    };

    systemd.services = {
      mealie-addons = {
        description = "Mealie addons - export recipes to various formats";
        after = ["network.target" "mealie.service"];
        wantedBy = ["multi-user.target"];

        path = [pkgs.pandoc];

        environment = {
          MEALIE_BASE_URL = "http://localhost:9000";
          MEALIE_RETRIEVAL_URL = "http://localhost:9000";
          MA_LISTEN_INTERFACE = ":9001";
          MA_RETRIEVAL_LIMIT = "0";
          MA_STARTUP_GRACE_SECS = "10";
          MA_TIMEOUT_SECS = "300";
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = pkgs.writeShellScript "mealie-addons-start" ''
            export MEALIE_TOKEN=$(cat $CREDENTIALS_DIRECTORY/mealie_token)
            exec ${mealie-addons-extracted}/bin/mealie-addons
          '';
          LoadCredential = "mealie_token:${config.sops.secrets.mealie_token.path}";
          Restart = "on-failure";
          RestartSec = "5s";

          DynamicUser = true;
          PrivateTmp = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
        };
      };

      mealie-export = {
        description = "Export Mealie recipes to markdown";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "/etc/mealie/export-recipes.sh";
        };
      };
    };

    systemd.timers.mealie-export = {
      description = "Daily Mealie recipe export timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 02:00:00";
        Persistent = true;
      };
    };
  };
}
