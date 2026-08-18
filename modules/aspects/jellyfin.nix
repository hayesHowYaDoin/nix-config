{den, ...}: {
  den.aspects.jellyfin = {
    includes = [
      (den.aspects.tailscale-funnel {
        name = "jellyfin";
        port = 8096;
      })
    ];

    nixos = {pkgs, ...}: {
      services.jellyfin.enable = true;
      environment.systemPackages = [
        pkgs.jellyfin
        pkgs.jellyfin-web
        pkgs.jellyfin-ffmpeg
      ];
    };
  };
}
