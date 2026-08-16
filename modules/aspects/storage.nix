{
  den.aspects.storage.nixos = {pkgs, ...}: let
    drive1 = "/dev/disk/by-id/ata-WDC_WD120EFGX-68CPHN0_WD-B015YWGD";
    drive2 = "/dev/disk/by-id/ata-WDC_WD120EFGX-68CPHN0_WD-B015XG2D";
    mountPoint = "/mnt/d";
  in {
    fileSystems.${mountPoint} = {
      device = drive1;
      fsType = "btrfs";
      options = [
        "compress=zstd:3"
        "space_cache=v2"
        "noatime"
        "commit=120"
        "nofail"
        "x-systemd.device-timeout=10"
        "x-systemd.automount"
      ];
    };

    environment.systemPackages = with pkgs; [
      btrfs-progs
      btrbk
    ];

    system.activationScripts.storage-setup = {
      text = ''
        mkdir -p ${mountPoint}

        if mountpoint -q ${mountPoint}; then
          mkdir -p ${mountPoint}/{.quarantine,.snapshots,torrents}

          if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show ${mountPoint}/media &>/dev/null; then
            echo "Creating btrfs subvolume: ${mountPoint}/media"
            ${pkgs.btrfs-progs}/bin/btrfs subvolume create ${mountPoint}/media
          fi

          if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show ${mountPoint}/.services &>/dev/null; then
            echo "Creating btrfs subvolume: ${mountPoint}/.services"
            ${pkgs.btrfs-progs}/bin/btrfs subvolume create ${mountPoint}/.services
          fi

          if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show ${mountPoint}/documents &>/dev/null; then
            echo "Creating btrfs subvolume: ${mountPoint}/documents"
            ${pkgs.btrfs-progs}/bin/btrfs subvolume create ${mountPoint}/documents
          fi

          chown jordan:users ${mountPoint}
          chmod 775 ${mountPoint}
          for dir in .quarantine torrents media documents; do
            if [ -e "${mountPoint}/$dir" ]; then
              chown -R jordan:users ${mountPoint}/$dir
              chmod -R 775 ${mountPoint}/$dir
            fi
          done

          if [ -e "${mountPoint}/.services" ]; then
            chown root:root ${mountPoint}/.services
            chmod 755 ${mountPoint}/.services
          fi

          chmod 755 ${mountPoint}/.snapshots 2>/dev/null || true
        fi
      '';
      deps = [];
    };

    systemd.services.btrfs-scrub = {
      description = "btrfs filesystem scrub for data integrity";

      script = ''
        echo "Starting btrfs scrub on ${mountPoint}" | \
          ${pkgs.systemd}/bin/systemd-cat -t btrfs-scrub -p info

        ${pkgs.btrfs-progs}/bin/btrfs scrub start -B ${mountPoint}

        ${pkgs.btrfs-progs}/bin/btrfs scrub status ${mountPoint} | \
          ${pkgs.systemd}/bin/systemd-cat -t btrfs-scrub -p info
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    };

    systemd.timers.btrfs-scrub = {
      description = "Monthly btrfs scrubbing schedule";
      wantedBy = ["timers.target"];

      timerConfig = {
        OnCalendar = "monthly";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };

    services.smartd = {
      enable = true;
      devices = [
        {
          device = drive1;
          options = "-a -o on -S on -s (S/../.././02|L/../../7/04)";
        }
        {
          device = drive2;
          options = "-a -o on -S on -s (S/../.././02|L/../../7/04)";
        }
      ];

      notifications = {
        wall.enable = true;
        mail = {
          enable = true;
          recipient = "jordanhayes98@gmail.com";
        };
      };
    };

    services.btrbk = {
      niceness = 19;
      ioSchedulingClass = "idle";

      instances.media-storage = {
        onCalendar = "03:00";
        settings = {
          timestamp_format = "long";
          snapshot_create = "onchange";
          snapshot_preserve_min = "7d";
          snapshot_preserve = "7d 4w 12m";
          volume.${mountPoint} = {
            snapshot_dir = "${mountPoint}/.snapshots";
            subvolume = {
              media = {};
              documents = {};
              ".services" = {};
            };
          };
        };
      };
    };
  };
}
