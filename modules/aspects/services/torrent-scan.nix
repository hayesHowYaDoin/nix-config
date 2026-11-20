{hayes, ...}: {
  hayes.torrent-scan = {
    downloads ? "/var/lib/qbittorrent/downloads",
    staging ? "/var/lib/qbittorrent/staging",
    quarantine ? "/var/lib/qbittorrent/quarantine",
    stateFile ? "/var/lib/qbittorrent/state.txt",
    interval ? "15min",
    ...
  }: {
    # Host runs no scanner. All scanning happens inside an nspawn
    # container (see modules/hosts/blackbart/scan-container.nix). The
    # host only orchestrates: enumerate downloads, dispatch to the
    # container, read the verdict, hardlink/quarantine based on result.
    nixos = {
      self,
      config,
      pkgs,
      ...
    }: {
      sops.secrets.virus_total_api_key = {};
      sops.secrets.ntfy_torrent_scan_url = {};

      environment.etc = {
        "torrent-scan/stage.nu" = {
          source = "${self}/scripts/filesystem/stage.nu";
          mode = "0755";
        };
        "torrent-scan/scan.nu" = {
          source = "${self}/scripts/filesystem/scan.nu";
          mode = "0755";
        };
        "torrent-scan/notify.nu" = {
          source = "${self}/scripts/filesystem/notify.nu";
          mode = "0755";
        };
        "torrent-scan/scan/mime-check.nu" = {
          source = "${self}/scripts/filesystem/scan/mime-check.nu";
          mode = "0755";
        };
        "torrent-scan/scan/hash-lookup.nu" = {
          source = "${self}/scripts/filesystem/scan/hash-lookup.nu";
          mode = "0755";
        };
        "torrent-scan/scan/virus-total.nu" = {
          source = "${self}/scripts/filesystem/scan/virus-total.nu";
          mode = "0755";
        };
        "torrent-scan/scan/sandbox.nu" = {
          source = "${self}/scripts/filesystem/scan/sandbox.nu";
          mode = "0755";
        };
        "torrent-scan/scan/clamscan.nu" = {
          source = "${self}/scripts/filesystem/scan/clamscan.nu";
          mode = "0755";
        };
      };

      systemd.services.torrent-scan = {
        description = "Scan new torrent downloads and promote to staging";
        path = with pkgs; [nushell coreutils util-linux file];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.nushell}/bin/nu /etc/torrent-scan/stage.nu \
              --downloads ${downloads} \
              --staging ${staging} \
              --quarantine ${quarantine} \
              --state-file ${stateFile} \
              --scan-script /etc/torrent-scan/scan.nu \
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
    };
  };
}
