{
  den.aspects.jellyfin.nixos = {pkgs, ...}: {
    services.jellyfin.enable = true;
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
  };
}
