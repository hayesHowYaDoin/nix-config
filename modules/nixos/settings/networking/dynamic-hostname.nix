{
  flake.modules.nixos.dynamic-hostname = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.networking.dynamicHostname;
  in {
    options.networking.dynamicHostname = {
      prefix = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = "Prefix for fallback hostname when using hardware serial (e.g., 'mort' gives 'mort-a1b2c3d4')";
      };
    };

    config = {
      networking.hostName = lib.mkDefault cfg.prefix;

      systemd.services.set-dynamic-hostname = {
        description = "Set hostname from provisioned file or hardware serial";
        wantedBy = ["sysinit.target"];
        before = ["network-pre.target" "systemd-hostnamed.service"];
        after = ["local-fs.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          if [ -f /etc/hostname.provisioned ]; then
            HOSTNAME=$(cat /etc/hostname.provisioned | tr -d '[:space:]')
            echo "Using provisioned hostname: $HOSTNAME"
          else
            SERIAL=""

            # Try devicetree first (cleaner, null-terminated)
            if [ -f /sys/firmware/devicetree/base/serial-number ]; then
              SERIAL=$(tr -d '\0' < /sys/firmware/devicetree/base/serial-number)
            # Fallback to cpuinfo
            elif [ -f /proc/cpuinfo ]; then
              SERIAL=$(${pkgs.gnugrep}/bin/grep -i "^Serial" /proc/cpuinfo | ${pkgs.gawk}/bin/awk '{print $3}')
            fi

            if [ -n "$SERIAL" ]; then
              # Take last 8 characters of serial for brevity
              SHORT_SERIAL=$(echo "$SERIAL" | tail -c 9 | head -c 8)
              HOSTNAME="${cfg.prefix}-$SHORT_SERIAL"
              echo "Using hardware serial hostname: $HOSTNAME"
            else
              echo "Warning: No provisioned hostname and could not determine serial, using default"
              HOSTNAME="${cfg.prefix}"
            fi
          fi

          if [ -n "$HOSTNAME" ]; then
            ${pkgs.hostname}/bin/hostname "$HOSTNAME"
          fi
        '';
      };
    };
  };
}
