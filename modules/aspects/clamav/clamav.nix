{
  den.aspects.clamav = {
    quarantineDir,
    logDir ? "/var/log/virus-scan",
    useVirusTotal ? false,
    ...
  }: {
    name = "clamav";
    nixos = {
      pkgs,
      config,
      lib,
      ...
    }: let
      vtApiKeyFile =
        if useVirusTotal
        then config.sops.secrets.virustotal_api_key.path
        else "";
    in {
      services.clamav = {
        daemon.enable = true;
        updater.enable = true;
      };

      sops.secrets = lib.mkIf useVirusTotal {
        virustotal_api_key = {
          owner = "root";
          mode = "0400";
        };
      };

      environment.systemPackages = with pkgs; [
        clamav
        inotify-tools
        curl
        jq
      ];

      system.activationScripts.clamav-setup = {
        text = ''
          mkdir -p ${quarantineDir}
          chown root:root ${quarantineDir}
          chmod 700 ${quarantineDir}

          mkdir -p ${logDir}
          chmod 755 ${logDir}

          mkdir -p /etc/virus-scan
        '';
        deps = [];
      };

      # scan-file.sh — runs ClamAV first, optionally escalates to VirusTotal.
      # Called per-file by clamav-watch's inotify service.
      environment.etc."virus-scan/scan-file.sh" = {
        text = ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          FILE="$1"
          QUARANTINE_DIR="${quarantineDir}"
          LOG_FILE="${logDir}/scan.log"
          ${
            if useVirusTotal
            then "VT_API_KEY_FILE=\"${vtApiKeyFile}\""
            else ""
          }
          VT_RATE_LIMIT_DELAY=15
          VT_TEST_MODE="''${VT_TEST_MODE:-}"

          log() {
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
          }

          quarantine_file() {
            local reason="$1"
            local quarantine_path="$QUARANTINE_DIR/$(basename "$FILE").$(date +%s)"

            log "INFECTED: $FILE"
            log "   Reason: $reason"
            log "   -> Quarantining to: $quarantine_path"

            mv "$FILE" "$quarantine_path"
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
            log "   ClamAV: Uncertain (exit code $CLAM_EXIT)"
          fi

          ${
            if useVirusTotal
            then ''
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
                fi
              fi
            ''
            else ""
          }

          exit 0
        '';
        mode = "0755";
      };
    };
  };
}
