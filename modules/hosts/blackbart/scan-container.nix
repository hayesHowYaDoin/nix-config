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
    yaraRules = pkgs.runCommand "yara-rules" {} ''
      mkdir -p $out
      cp -r ${inputs.yara-signature-base}/yara/. $out/
    '';
  in {
    # Host owns the ClamAV sig DB (freshclam updates it); the container
    # bind-mounts it read-only.
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

    systemd.slices."torrent-scan-container" = {
      description = "Resource slice for the torrent-scan nspawn container";
      sliceConfig = {
        MemoryMax = "8G";
        CPUWeight = 50;
        IOWeight = 50;
      };
    };

    containers.torrent-scan = {
      autoStart = false; # Started on demand
      ephemeral = true; # Fresh each launch
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

        environment.etc."nu/filesystem" = {
          source = "${self}/scripts/filesystem";
          mode = "0755";
        };

        systemd.services.scan-runner = {
          wantedBy = ["multi-user.target"];
          path = with pkgs; [nushell clamav yara coreutils systemd];
          serviceConfig = {
            Type = "oneshot";
            TimeoutStartSec = "5min";
            ExecStart = "${pkgs.nushell}/bin/nu /etc/nu/filesystem/scan/runner.nu";
            Environment = "NU_LIB_DIRS=/etc/nu:/etc/nu/filesystem";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
          };
        };
      };
    };

    systemd.services."container@torrent-scan".serviceConfig = {
      Slice = lib.mkForce "torrent-scan-container.slice";
      Restart = lib.mkForce "no";
    };
  };
}
