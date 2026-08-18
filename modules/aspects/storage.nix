{
  den.aspects.storage = {
    devices,
    mountPoint,
    user,
    fsType ? "btrfs",
    subvolumes ? ["media" ".services" "documents"],
    plainDirs ? [".quarantine" ".snapshots" "torrents"],
    mountOptions ? [
      "compress=zstd:3"
      "space_cache=v2"
      "noatime"
      "commit=120"
      "nofail"
      "x-systemd.device-timeout=10"
      "x-systemd.automount"
    ],
    smartMailRecipient ? null,
    ...
  }: {
    name = "storage";
    nixos = {pkgs, ...}: {
      fileSystems.${mountPoint} = {
        # For btrfs RAID, mount using any single member; kernel finds the rest.
        device = builtins.head devices;
        inherit fsType;
        options = mountOptions;
      };

      environment.systemPackages = with pkgs; [
        btrfs-progs
        btrbk
      ];

      system.activationScripts.storage-setup = {
        text = ''
          mkdir -p ${mountPoint}

          if mountpoint -q ${mountPoint}; then
            ${builtins.concatStringsSep "\n" (map (d: "mkdir -p ${mountPoint}/${d}") plainDirs)}

            ${builtins.concatStringsSep "\n" (map (sv: ''
                if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show ${mountPoint}/${sv} &>/dev/null; then
                  echo "Creating btrfs subvolume: ${mountPoint}/${sv}"
                  ${pkgs.btrfs-progs}/bin/btrfs subvolume create ${mountPoint}/${sv}
                fi
              '')
              subvolumes)}

            chown ${user}:users ${mountPoint}
            chmod 775 ${mountPoint}
            ${builtins.concatStringsSep "\n" (map (d: ''
                if [ -e "${mountPoint}/${d}" ]; then
                  chown -R ${user}:users ${mountPoint}/${d}
                  chmod -R 775 ${mountPoint}/${d}
                fi
              '') (plainDirs ++ (builtins.filter (sv: sv != ".services") subvolumes)))}

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
        devices = map (dev: {
          device = dev;
          options = "-a -o on -S on -s (S/../.././02|L/../../7/04)";
        }) devices;

        notifications = {
          wall.enable = true;
          mail = pkgs.lib.mkIf (smartMailRecipient != null) {
            enable = true;
            recipient = smartMailRecipient;
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
              subvolume = builtins.listToAttrs (map (sv: {
                  name = sv;
                  value = {};
                })
                subvolumes);
            };
          };
        };
      };
    };
  };
}
