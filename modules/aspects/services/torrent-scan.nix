{hayes, ...}: {
  hayes.torrent-scan = {
    downloads ? "/var/lib/qbittorrent/downloads",
    staging ? "/var/lib/qbittorrent/staging",
    quarantine ? "/var/lib/qbittorrent/quarantine",
    stateFile ? "/var/lib/qbittorrent/state.txt",
    interval ? "15min",
    quarantineRetentionDays ? 30,
    runnerLog ? "/var/lib/torrent-scan/runner.log",
    ...
  }: {
    includes = [hayes.scripts];
    nixos = {
      config,
      pkgs,
      ...
    }: {
      nu.enabledPackages = ["filesystem"];

      sops.secrets.virus_total_api_key = {};
      sops.secrets.ntfy_torrent_scan_url = {};

      systemd.services.torrent-scan = {
        description = "Scan new torrent downloads and promote to staging";
        path = with pkgs; [nushell coreutils util-linux file];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.nushell}/bin/nu /etc/nu/filesystem/scan/stage.nu \
              --downloads ${downloads} \
              --staging ${staging} \
              --quarantine ${quarantine} \
              --state-file ${stateFile} \
              --scan-script /etc/nu/filesystem/scan/scan.nu \
              --vt-api-key-file ${config.sops.secrets.virus_total_api_key.path} \
              --ntfy-url-file ${config.sops.secrets.ntfy_torrent_scan_url.path}
          '';
        };
      };

      systemd.timers.torrent-scan = {
        description = "Periodically scan new torrent downloads";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "2min";
          OnUnitActiveSec = interval;
          Unit = "torrent-scan.service";
        };
      };

      systemd.services.torrent-scan-prune-quarantine = {
        description = "Prune aged quarantine entries";
        path = [pkgs.findutils];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.findutils}/bin/find ${quarantine} -type f -mtime +${toString quarantineRetentionDays} -delete
          '';
          ExecStartPost = ''
            ${pkgs.findutils}/bin/find ${quarantine} -mindepth 1 -type d -empty -delete
          '';
        };
      };

      systemd.timers.torrent-scan-prune-quarantine = {
        description = "Weekly quarantine prune";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
          RandomizedDelaySec = "1h";
          Unit = "torrent-scan-prune-quarantine.service";
        };
      };

      services.logrotate.enable = true;
      services.logrotate.settings.torrent-scan-runner = {
        files = [runnerLog];
        frequency = "weekly";
        rotate = 4;
        compress = true;
        delaycompress = true;
        missingok = true;
        notifempty = true;
        copytruncate = true;
      };
    };
  };
}
