{hayes, ...}: {
  hayes.vpn-stack = {
    downloadsDir,
    ...
  }: {
    includes = with hayes; [
      (prowlarr {})
      (qbittorrent {inherit downloadsDir;})
    ];
  };
}
