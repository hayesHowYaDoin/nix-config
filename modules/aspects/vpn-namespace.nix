{
  den.aspects.vpn-namespace.nixos = {pkgs, ...}: {
    environment.systemPackages = [pkgs.iproute2];

    systemd.services.vpn-netns-setup = {
      description = "Setup VPN-isolated network namespace for torrent services";
      after = ["network-online.target" "wgnord-connect.service"];
      wants = ["network-online.target"];
      requires = ["wgnord-connect.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
      };

      script = ''
              set -e

              NS="vpn"
              VETH_HOST="veth-vpn"
              VETH_NS="veth-vpn-ns"
              NS_IP="10.200.200.2/24"
              HOST_IP="10.200.200.1/24"
              VPN_INTERFACE="wgnord"
              VPN_DNS="103.86.96.100"

              if ! ${pkgs.iproute2}/bin/ip link show "$VPN_INTERFACE" &>/dev/null; then
                echo "ERROR: VPN interface $VPN_INTERFACE not found. Refusing to start VPN namespace."
                exit 1
              fi

              if ! ${pkgs.iproute2}/bin/ip netns list | grep -q "^$NS"; then
                echo "Creating network namespace: $NS"
                ${pkgs.iproute2}/bin/ip netns add "$NS"
              fi

              if ! ${pkgs.iproute2}/bin/ip link show "$VETH_HOST" &>/dev/null; then
                echo "Creating veth pair: $VETH_HOST <-> $VETH_NS"
                ${pkgs.iproute2}/bin/ip link add "$VETH_HOST" type veth peer name "$VETH_NS"

                ${pkgs.iproute2}/bin/ip link set "$VETH_NS" netns "$NS"

                ${pkgs.iproute2}/bin/ip addr add "$HOST_IP" dev "$VETH_HOST"
                ${pkgs.iproute2}/bin/ip link set "$VETH_HOST" up

                ${pkgs.iproute2}/bin/ip netns exec "$NS" ${pkgs.iproute2}/bin/ip addr add "$NS_IP" dev "$VETH_NS"
                ${pkgs.iproute2}/bin/ip netns exec "$NS" ${pkgs.iproute2}/bin/ip link set "$VETH_NS" up
                ${pkgs.iproute2}/bin/ip netns exec "$NS" ${pkgs.iproute2}/bin/ip link set lo up

                ${pkgs.iproute2}/bin/ip netns exec "$NS" ${pkgs.iproute2}/bin/ip route add default via 10.200.200.1

                ${pkgs.iproute2}/bin/ip netns exec "$NS" ${pkgs.procps}/bin/sysctl -w net.ipv6.conf.all.disable_ipv6=1
                ${pkgs.iproute2}/bin/ip netns exec "$NS" ${pkgs.procps}/bin/sysctl -w net.ipv6.conf.default.disable_ipv6=1
              fi

              echo "Setting up NAT through $VPN_INTERFACE"

              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.200.200.0/24 -o "$VPN_INTERFACE" -j MASQUERADE 2>/dev/null || true
              ${pkgs.iptables}/bin/iptables -D FORWARD -i "$VETH_HOST" -o "$VPN_INTERFACE" -j ACCEPT 2>/dev/null || true
              ${pkgs.iptables}/bin/iptables -D FORWARD -i "$VPN_INTERFACE" -o "$VETH_HOST" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true

              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o "$VPN_INTERFACE" -j MASQUERADE
              ${pkgs.iptables}/bin/iptables -A FORWARD -i "$VETH_HOST" -o "$VPN_INTERFACE" -j ACCEPT
              ${pkgs.iptables}/bin/iptables -A FORWARD -i "$VPN_INTERFACE" -o "$VETH_HOST" -m state --state RELATED,ESTABLISHED -j ACCEPT

              ${pkgs.iptables}/bin/iptables -D FORWARD -i "$VETH_HOST" ! -o "$VPN_INTERFACE" -j REJECT 2>/dev/null || true
              ${pkgs.iptables}/bin/iptables -A FORWARD -i "$VETH_HOST" ! -o "$VPN_INTERFACE" -j REJECT

              mkdir -p /etc/netns/"$NS"
              cat > /etc/netns/"$NS"/resolv.conf << EOF
        nameserver $VPN_DNS
        options edns0 trust-ad
        EOF

              echo "VPN network namespace setup complete."
      '';

      preStop = ''
        NS="vpn"
        VETH_HOST="veth-vpn"
        VPN_INTERFACE="wgnord"

        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.200.200.0/24 -o "$VPN_INTERFACE" -j MASQUERADE 2>/dev/null || true
        ${pkgs.iptables}/bin/iptables -D FORWARD -i "$VETH_HOST" -o "$VPN_INTERFACE" -j ACCEPT 2>/dev/null || true
        ${pkgs.iptables}/bin/iptables -D FORWARD -i "$VPN_INTERFACE" -o "$VETH_HOST" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
        ${pkgs.iptables}/bin/iptables -D FORWARD -i "$VETH_HOST" ! -o "$VPN_INTERFACE" -j REJECT 2>/dev/null || true

        ${pkgs.iproute2}/bin/ip link delete "$VETH_HOST" 2>/dev/null || true

        ${pkgs.iproute2}/bin/ip netns delete "$NS" 2>/dev/null || true

        rm -rf /etc/netns/"$NS" 2>/dev/null || true
      '';
    };
  };
}
