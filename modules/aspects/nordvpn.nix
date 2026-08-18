{
  den.aspects.nordvpn = {
    region ? "us",
    ...
  }: {
    name = "nordvpn";
    nixos = {
      pkgs,
      config,
      ...
    }: {
      sops.secrets.nordvpn_token = {
        owner = "root";
        mode = "0400";
      };

      environment.systemPackages = with pkgs; [
        wgnord
        wireguard-tools
      ];

      boot.kernelModules = ["wireguard"];

      system.activationScripts.wgnord-template = {
        text = ''
                mkdir -p /var/lib/wgnord
                cat > /var/lib/wgnord/template.conf << 'EOF'
          [Interface]
          PrivateKey = PRIVKEY
          Address = 10.5.0.2/32
          MTU = 1420
          DNS = 103.86.96.100

          # Exclude Tailscale traffic from wgnord tunnel (runs after WireGuard setup)
          PostUp = ip rule add to 100.64.0.0/10 lookup 52 priority 10 || true
          PostUp = ip rule add from 100.64.0.0/10 lookup 52 priority 10 || true
          PreDown = ip rule del to 100.64.0.0/10 lookup 52 priority 10 || true
          PreDown = ip rule del from 100.64.0.0/10 lookup 52 priority 10 || true

          [Peer]
          PublicKey = SERVER_PUBKEY
          AllowedIPs = 0.0.0.0/0, ::/0
          Endpoint = SERVER_IP:51820
          PersistentKeepalive = 25
          EOF
                chmod 600 /var/lib/wgnord/template.conf
        '';
        deps = [];
      };

      systemd.services.wgnord-connect = {
        description = "Connect to NordVPN via wgnord";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          TimeoutStartSec = "60s";
          Restart = "on-failure";
          RestartSec = "15s";
          LoadCredential = "nordvpn_token:${config.sops.secrets.nordvpn_token.path}";
        };

        script = ''
          # Register the NordVPN token from sops if not already registered.
          # wgnord persists the registration in /var/lib/wgnord/; token file
          # presence is our idempotency check.
          if [ ! -f /var/lib/wgnord/token ]; then
            echo "Registering NordVPN token..."
            ${pkgs.wgnord}/bin/wgnord token "$(cat $CREDENTIALS_DIRECTORY/nordvpn_token)"
          fi

          # Force a clean disconnect/reconnect to ensure PostUp hooks execute
          if ${pkgs.wireguard-tools}/bin/wg show wgnord &>/dev/null; then
            echo "wgnord already connected, disconnecting first..."
            ${pkgs.wgnord}/bin/wgnord d || true
            sleep 1
          fi

          echo "Connecting to NordVPN (${region})..."
          ${pkgs.wgnord}/bin/wgnord c ${region}
        '';

        preStop = ''
          echo "Disconnecting from NordVPN..."
          ${pkgs.wgnord}/bin/wgnord d || true
        '';
      };
    };
  };
}
