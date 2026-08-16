{
  den.aspects.clamav.nixos = {
    pkgs,
    config,
    ...
  }: let
    downloadsDir = "/mnt/d/torrents";
    quarantineDir = "/mnt/d/.quarantine";
    logDir = "/var/log/virus-scan";
    vtApiKeyFile = config.sops.secrets.virustotal_api_key.path;
  in {
    sops.secrets.virustotal_api_key = {
      owner = "root";
      mode = "0400";
    };

    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
    };

    environment.systemPackages = with pkgs; [
      clamav
      inotify-tools
      curl
      jq
    ];

    system.activationScripts.virus-scan-setup = {
      text = ''
        mkdir -p ${quarantineDir}
        chown jordan:users ${quarantineDir}
        chmod 700 ${quarantineDir}

        mkdir -p ${logDir}
        chmod 755 ${logDir}

        mkdir -p /etc/virus-scan
      '';
      deps = [];
    };

    environment.etc."virus-scan/scan-file.sh" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        FILE="$1"
        QUARANTINE_DIR="${quarantineDir}"
        LOG_FILE="${logDir}/scan.log"
        VT_API_KEY_FILE="${vtApiKeyFile}"
        VT_RATE_LIMIT_DELAY=15
        VT_TEST_MODE="''${VT_TEST_MODE:-}"

        log() {
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
        }

        notify_user() {
          local title="$1"
          local message="$2"
          local urgency="''${3:-normal}"

          if command -v notify-send &> /dev/null; then
            sudo -u jordan DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
              ${pkgs.libnotify}/bin/notify-send -u "$urgency" "$title" "$message" || true
          fi
        }

        quarantine_file() {
          local reason="$1"
          local quarantine_path="$QUARANTINE_DIR/$(basename "$FILE").$(date +%s)"

          log "INFECTED: $FILE"
          log "   Reason: $reason"
          log "   -> Quarantining to: $quarantine_path"

          mv "$FILE" "$quarantine_path"
          notify_user "Virus Detected!" "File quarantined: $(basename "$FILE")\nReason: $reason" "critical"

          exit 1
        }

        if [[ ! -f "$FILE" ]] || [[ -d "$FILE" ]]; then
          exit 0
        fi

        if [[ "$FILE" == "$QUARANTINE_DIR"* ]]; then
          exit 0
        fi

        FILE_SIZE=$(stat -c%s "$FILE" 2>/dev/null || echo 0)
        if [[ $FILE_SIZE -lt 50 ]]; then
          log "Skipping tiny file: $FILE ($FILE_SIZE bytes)"
          exit 0
        fi

        log "Scanning: $FILE ($(numfmt --to=iec-i --suffix=B $FILE_SIZE))"

        log "   [Stage 1] ClamAV scan starting..."

        set +e
        CLAM_OUTPUT=$(${pkgs.clamav}/bin/clamdscan --no-summary "$FILE" 2>&1)
        CLAM_EXIT=$?
        set -e

        if [[ $CLAM_EXIT -eq 0 ]]; then
          log "   ClamAV: Clean"
          if [[ "$VT_TEST_MODE" != "1" ]]; then
            exit 0
          fi
        elif [[ $CLAM_EXIT -eq 1 ]]; then
          VIRUS_NAME=$(echo "$CLAM_OUTPUT" | grep "FOUND" | awk '{print $2}' || echo "Unknown")
          log "   ClamAV: Detected $VIRUS_NAME"
          if [[ "$VT_TEST_MODE" != "1" ]]; then
            quarantine_file "ClamAV detected: $VIRUS_NAME"
          fi
        else
          log "   ClamAV: Uncertain (exit code $CLAM_EXIT), escalating to VirusTotal..."
        fi

        log "   [Stage 2] VirusTotal scan starting..."

        if [[ ! -f "$VT_API_KEY_FILE" ]]; then
          log "   VirusTotal API key not found at $VT_API_KEY_FILE"
          exit 0
        fi

        VT_API_KEY=$(cat "$VT_API_KEY_FILE")

        FILE_SHA256=$(${pkgs.coreutils}/bin/sha256sum "$FILE" | awk '{print $1}')
        log "   File hash: $FILE_SHA256"

        VT_RESPONSE=$(${pkgs.curl}/bin/curl -s \
          --request GET \
          --url "https://www.virustotal.com/api/v3/files/$FILE_SHA256" \
          --header "x-apikey: $VT_API_KEY" || echo '{"error":true}')

        if echo "$VT_RESPONSE" | ${pkgs.jq}/bin/jq -e '.data.attributes.last_analysis_stats' &>/dev/null; then
          log "   Hash found in VirusTotal database"

          MALICIOUS=$(echo "$VT_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.attributes.last_analysis_stats.malicious // 0')
          SUSPICIOUS=$(echo "$VT_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.attributes.last_analysis_stats.suspicious // 0')
          TOTAL_ENGINES=$(echo "$VT_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.attributes.last_analysis_stats | to_entries | map(.value) | add')

          log "   VirusTotal results: $MALICIOUS malicious, $SUSPICIOUS suspicious (out of $TOTAL_ENGINES engines)"

          if [[ $MALICIOUS -gt 0 ]] || [[ $SUSPICIOUS -gt 2 ]]; then
            quarantine_file "VirusTotal: $MALICIOUS/$TOTAL_ENGINES engines flagged as malicious"
          else
            log "   VirusTotal: Clean"
            exit 0
          fi
        else
          log "   Hash not found, uploading file to VirusTotal..."
          sleep $VT_RATE_LIMIT_DELAY

          UPLOAD_RESPONSE=$(${pkgs.curl}/bin/curl -s \
            --request POST \
            --url 'https://www.virustotal.com/api/v3/files' \
            --header "x-apikey: $VT_API_KEY" \
            --form "file=@$FILE" || echo '{"error":true}')

          ANALYSIS_ID=$(echo "$UPLOAD_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.id // empty')

          if [[ -z "$ANALYSIS_ID" ]]; then
            log "   VirusTotal upload failed"
            exit 0
          fi

          log "   File uploaded, analysis ID: $ANALYSIS_ID"
          sleep 30

          ANALYSIS_RESPONSE=$(${pkgs.curl}/bin/curl -s \
            --request GET \
            --url "https://www.virustotal.com/api/v3/analyses/$ANALYSIS_ID" \
            --header "x-apikey: $VT_API_KEY" || echo '{"error":true}')

          MALICIOUS=$(echo "$ANALYSIS_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.attributes.stats.malicious // 0')
          SUSPICIOUS=$(echo "$ANALYSIS_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.attributes.stats.suspicious // 0')
          TOTAL_ENGINES=$(echo "$ANALYSIS_RESPONSE" | ${pkgs.jq}/bin/jq -r '.data.attributes.stats | to_entries | map(.value) | add')

          log "   VirusTotal analysis complete: $MALICIOUS/$TOTAL_ENGINES engines flagged"

          if [[ $MALICIOUS -gt 0 ]] || [[ $SUSPICIOUS -gt 2 ]]; then
            quarantine_file "VirusTotal: $MALICIOUS/$TOTAL_ENGINES engines flagged as malicious"
          else
            log "   VirusTotal: Clean"
            exit 0
          fi
        fi
      '';
      mode = "0755";
    };

    systemd.services.clamav-daily-scan = {
      description = "Daily ClamAV scan of D drive";
      after = ["clamav-daemon.service"];
      requires = ["clamav-daemon.service"];

      serviceConfig = {
        Type = "oneshot";
        Nice = 19;
        IOSchedulingClass = "idle";
      };

      script = ''
        SCAN_LOG="${logDir}/daily-scan.log"
        SCAN_DATE=$(date '+%Y-%m-%d %H:%M:%S')

        echo "[$SCAN_DATE] Starting daily scan of /mnt/d" | tee -a "$SCAN_LOG"

        ${pkgs.clamav}/bin/clamscan \
          --recursive \
          --verbose \
          --move=${quarantineDir} \
          --exclude-dir="^${quarantineDir}" \
          /mnt/d 2>&1 | tee -a "$SCAN_LOG"

        SCAN_EXIT=''${PIPESTATUS[0]}
        SCAN_END=$(date '+%Y-%m-%d %H:%M:%S')

        echo "[$SCAN_END] Daily scan completed with exit code: $SCAN_EXIT" | tee -a "$SCAN_LOG"

        if command -v notify-send &> /dev/null; then
          if [[ $SCAN_EXIT -eq 0 ]]; then
            sudo -u jordan DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
              ${pkgs.libnotify}/bin/notify-send "Daily Virus Scan Complete" "No threats detected" -u normal || true
          elif [[ $SCAN_EXIT -eq 1 ]]; then
            INFECTED_COUNT=$(grep "Infected files:" "$SCAN_LOG" | tail -1 | awk '{print $3}')
            sudo -u jordan DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
              ${pkgs.libnotify}/bin/notify-send "Daily Virus Scan: Threats Found!" "$INFECTED_COUNT infected files quarantined" -u critical || true
          fi
        fi
      '';
    };

    systemd.timers.clamav-daily-scan = {
      description = "Daily ClamAV scan timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "02:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };
    };

    systemd.services.virus-scan-watcher = {
      description = "Virus scan watcher for torrent downloads";
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
        echo "Starting virus scan watcher for: ${downloadsDir}"

        if [[ ! -d "${downloadsDir}" ]]; then
          echo "Creating directory..."
          mkdir -p ${downloadsDir}
        fi

        ${pkgs.inotify-tools}/bin/inotifywait -m -r \
          -e close_write -e moved_to \
          --exclude '\.part$|\.!qB$|${quarantineDir}' \
          --format '%w%f' \
          ${downloadsDir} | while read -r FILE; do

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
}
