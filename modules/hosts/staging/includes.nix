{hayes, ...}: {
  den.aspects.staging.includes = with hayes; [
    network-manager
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
    (gnome {autoLoginUser = "jordan";})
  ];
}
