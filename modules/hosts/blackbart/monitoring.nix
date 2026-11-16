{
  den.aspects.blackbart.nixos = {pkgs, ...}: let
    healthchecksUrl = "https://hc-ping.com/864f901f-17e1-4247-ac12-dc8fb1345bed";
    handshakeFreshnessSec = 180;
  in {
    systemd.services.tunnel-liveness-check = {
      description = "Verify wgnord is passing traffic and ping Healthchecks.io";
      after = ["wg-quick-wgnord.service" "network-online.target"];
      wants = ["network-online.target"];
      path = with pkgs; [wireguard-tools curl coreutils];

      serviceConfig.Type = "oneshot";

      script = ''
        hc="${healthchecksUrl}"

        fail() {
          curl -fsS --max-time 10 --data "$1" "$hc/fail" >/dev/null || true
          exit 0
        }

        # Handshake must be recent. `wg show <iface> latest-handshakes`
        # prints `<pubkey>\t<unix-timestamp>`. A value of 0 means no
        # handshake has happened yet.
        handshake=$(wg show wgnord latest-handshakes 2>/dev/null | cut -f2)
        [ -n "$handshake" ] || fail "wg_interface_missing"
        [ "$handshake" != "0" ] || fail "no_handshake_yet"

        age=$(( $(date +%s) - handshake ))
        [ "$age" -lt ${toString handshakeFreshnessSec} ] || fail "handshake_stale=$age"

        # The success ping itself exits via the tunnel (default route is
        # wgnord). If the tunnel is dead but the handshake looks fresh,
        # this curl will fail, no healthy ping arrives at Healthchecks,
        # and its missed-ping alarm fires anyway.
        curl -fsS --max-time 10 "$hc" >/dev/null || true
      '';
    };

    systemd.timers.tunnel-liveness-check = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "5min";
        Unit = "tunnel-liveness-check.service";
      };
    };
  };
}
