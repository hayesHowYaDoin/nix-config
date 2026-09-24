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
    audio
    hyprland
    (sddm {autoLoginUser = "jordan";})
  ];
}
