{hayes, ...}: {
  den.aspects.staging.includes = with hayes; [
    tailscale
    tailscale-ssh
    vm-guest
    uptime-kuma
    audiobookshelf
    jellyfin
    jellyseerr
    radarr
    sonarr
    (byparr {})
    budgetviz
  ];
}
