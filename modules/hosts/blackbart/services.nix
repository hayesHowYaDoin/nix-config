{hayes, ...}: {
  den.aspects.blackbart.includes = with hayes; [
    (qbittorrent {downloadsDir = "/var/lib/qbittorrent/downloads";})
    (prowlarr {})
    radarr
    sonarr
  ];
}
