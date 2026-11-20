{
  self,
  inputs,
  ...
}: {
  den.aspects.blackbart.nixos = {
    lib,
    pkgs,
    ...
  }: let
    # YARA rules from Neo23x0/signature-base, pinned via flake input.
    # Only the yara/ subdir is relevant; everything else in that repo is
    # ClamAV sigs or IOCs for other tools. Materialize as a plain
    # directory in the store so it can be bind-mounted into the
    # container read-only.
    yaraRules = pkgs.runCommand "yara-rules" {} ''
      mkdir -p $out
      cp -r ${inputs.yara-signature-base}/yara/. $out/
    '';
  in {
    # Host owns the ClamAV sig DB (freshclam updates it); the container
    # bind-mounts it read-only. Third-party SaneSecurity feeds roughly
    # double real-world detection vs. the default ClamAV set, especially
    # on recent PE/PHP/malscript payloads.
    services.clamav.updater.enable = true;
    services.clamav.updater.settings = {
      DatabaseCustomURL = [
        "https://ftp.swin.edu.au/sanesecurity/sanesecurity.ftm"
        "https://ftp.swin.edu.au/sanesecurity/junk.ndb"
        "https://ftp.swin.edu.au/sanesecurity/jurlbl.ndb"
        "https://ftp.swin.edu.au/sanesecurity/phish.ndb"
        "https://ftp.swin.edu.au/sanesecurity/rogue.hdb"
        "https://ftp.swin.edu.au/sanesecurity/scam.ndb"
        "https://ftp.swin.edu.au/sanesecurity/winnow_malware.hdb"
        "https://ftp.swin.edu.au/sanesecurity/winnow_malware_links.ndb"
        "https://ftp.swin.edu.au/sanesecurity/winnow.attachments.hdb"
        "https://ftp.swin.edu.au/sanesecurity/winnow_extended_malware.hdb"
        "https://ftp.swin.edu.au/sanesecurity/foxhole_filename.cdb"
        "https://ftp.swin.edu.au/sanesecurity/foxhole_generic.cdb"
      ];
    };

    # Resource cap on the container's cgroup slice.
    systemd.slices."torrent-scan-container" = {
      description = "Resource slice for the torrent-scan nspawn container";
      sliceConfig = {
        MemoryMax = "8G";
        CPUWeight = 50;
        IOWeight = 50;
      };
    };

    # Declarative NixOS container. `autoStart = false` keeps it off at
    # boot; sandbox.nu starts it on demand. `ephemeral = true` gives
    # every launch a fresh overlayfs rootfs — no state persists between
    # scans.
    containers.torrent-scan = {
      autoStart = false;
      ephemeral = true;
      privateNetwork = true;
      enableTun = false;

      bindMounts = {
        "/var/lib/clamav" = {
          hostPath = "/var/lib/clamav";
          isReadOnly = true;
        };
        "/var/lib/yara-rules" = {
          hostPath = "${yaraRules}";
          isReadOnly = true;
        };
        "/torrent-scan" = {
          hostPath = "/var/lib/torrent-scan";
          isReadOnly = false;
        };
      };

      config = {pkgs, ...}: {
        system.stateVersion = "25.11";

        environment.systemPackages = [pkgs.clamav pkgs.yara pkgs.nushell];
        environment.etc."torrent-scan/runner.nu".source =
          "${self}/scripts/filesystem/scan/runner.nu";
        environment.etc."torrent-scan/clamscan.nu".source =
          "${self}/scripts/filesystem/scan/clamscan.nu";
        environment.etc."torrent-scan/yara.nu".source =
          "${self}/scripts/filesystem/scan/yara.nu";

        systemd.services.scan-runner = {
          wantedBy = ["multi-user.target"];
          path = with pkgs; [nushell clamav yara coreutils systemd];
          serviceConfig = {
            Type = "oneshot";
            TimeoutStartSec = "5min";
            ExecStart = "${pkgs.nushell}/bin/nu /etc/torrent-scan/runner.nu";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
          };
        };
      };
    };

    # Place the container's systemd unit in our resource-capped slice,
    # and prevent auto-restart. Container is one-shot per scan; sandbox.nu
    # explicitly starts it, tolerates non-zero exit, and reads the done
    # file written by runner.nu as ground truth.
    systemd.services."container@torrent-scan".serviceConfig = {
      Slice = lib.mkForce "torrent-scan-container.slice";
      Restart = lib.mkForce "no";
    };
  };
}
