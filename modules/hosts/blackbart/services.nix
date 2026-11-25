{hayes, ...}: {
  den.aspects.blackbart.includes = with hayes; [
    (qbittorrent {
      downloadsDir = "/var/lib/qbittorrent/downloads";
      incompleteDir = "/var/lib/qbittorrent/incomplete";
    })
    (prowlarr {})
    radarr
    sonarr
    (torrent-scan {
      interval = "1min";
      quarantineRetentionDays = 7;
    })
    (ntfy {})
  ];
}
