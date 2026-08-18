{
  den.aspects.clamav-scan = {
    scanDirs,
    quarantineDir,
    logDir ? "/var/log/virus-scan",
    schedule ? "02:00",
    den,
    ...
  }: {
    name = "clamav-scan";
    includes = [
      (den.aspects.clamav {
        inherit quarantineDir logDir;
      })
    ];
    nixos = {pkgs, ...}: {
      systemd.services.clamav-scan = {
        description = "Scheduled ClamAV scan of ${builtins.concatStringsSep ", " scanDirs}";
        after = ["clamav-daemon.service"];
        requires = ["clamav-daemon.service"];

        serviceConfig = {
          Type = "oneshot";
          Nice = 19;
          IOSchedulingClass = "idle";
        };

        script = ''
          SCAN_LOG="${logDir}/scheduled-scan.log"
          SCAN_DATE=$(date '+%Y-%m-%d %H:%M:%S')

          echo "[$SCAN_DATE] Starting scan of ${builtins.concatStringsSep " " scanDirs}" | tee -a "$SCAN_LOG"

          ${pkgs.clamav}/bin/clamscan \
            --recursive \
            --verbose \
            --move=${quarantineDir} \
            --exclude-dir="^${quarantineDir}" \
            ${builtins.concatStringsSep " " scanDirs} 2>&1 | tee -a "$SCAN_LOG"

          SCAN_EXIT=''${PIPESTATUS[0]}
          SCAN_END=$(date '+%Y-%m-%d %H:%M:%S')

          echo "[$SCAN_END] Scan completed with exit code: $SCAN_EXIT" | tee -a "$SCAN_LOG"
        '';
      };

      systemd.timers.clamav-scan = {
        description = "ClamAV scheduled scan timer";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = schedule;
          Persistent = true;
          RandomizedDelaySec = "30m";
        };
      };
    };
  };
}
