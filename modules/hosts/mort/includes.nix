{hayes, ...}: {
  den.aspects.mort.includes = with hayes; [
    sops
    network-manager
    tailscale
    tailscale-ssh
    tailscale-exit-node
    ip-forwarding
    (nordvpn {})
    vpn-namespace
    (vpn-namespaced {
      name = "alpha";
      user = "prowlarr";
      port = 9696;
      execCommand = pkgs: "${pkgs.prowlarr}/bin/Prowlarr -nobrowser";
    })
    (vpn-namespaced {
      name = "bravo";
      user = "qbittorrent";
      port = 8080;
      execCommand = pkgs: "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8080";
    })
    (vpn-namespaced {
      name = "charlie";
      user = "prowlarr";
      port = 9697;
      execCommand = pkgs: "echo charlie";
    })
  ];
}
