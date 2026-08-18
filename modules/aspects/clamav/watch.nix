{
  den.aspects.clamav-watch = {
    watchDirs,
    quarantineDir,
    logDir ? "/var/log/virus-scan",
    useVirusTotal ? false,
    den,
    ...
  }: {
    name = "clamav-watch";
    includes = [
      (den.aspects.clamav {
        inherit quarantineDir logDir useVirusTotal;
      })
    ];
    nixos = {pkgs, ...}: {
      systemd.services.virus-scan-watcher = {
        description = "ClamAV watcher for ${builtins.concatStringsSep ", " watchDirs}";
        after = ["clamav-daemon.service"];
        requires = ["clamav-daemon.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "10s";
        };

        script = ''
          echo "Waiting for ClamAV daemon..."
          while ! ${pkgs.clamav}/bin/clamdscan --ping 1 2>/dev/null; do
            sleep 2
          done

          echo "ClamAV daemon ready."
          echo "Starting watcher on: ${builtins.concatStringsSep " " watchDirs}"

          ${builtins.concatStringsSep "\n" (map (d: ''
              if [[ ! -d "${d}" ]]; then
                echo "Creating watch directory: ${d}"
                mkdir -p ${d}
              fi
            '')
            watchDirs)}

          ${pkgs.inotify-tools}/bin/inotifywait -m -r \
            -e close_write -e moved_to \
            --exclude '\.part$|\.!qB$|${quarantineDir}' \
            --format '%w%f' \
            ${builtins.concatStringsSep " " watchDirs} | while read -r FILE; do

            [[ ! -f "$FILE" ]] && continue

            sleep 3

            SIZE1=$(stat -c%s "$FILE" 2>/dev/null || echo 0)
            sleep 2
            SIZE2=$(stat -c%s "$FILE" 2>/dev/null || echo 0)

            if [[ $SIZE1 -eq $SIZE2 ]] && [[ $SIZE1 -gt 0 ]]; then
              echo "New file detected: $FILE"
              /etc/virus-scan/scan-file.sh "$FILE" &
            fi
          done
        '';
      };
    };
  };
}
