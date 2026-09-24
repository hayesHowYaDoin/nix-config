{
  hayes.radarr.nixos = {pkgs, ...}: {
    services.radarr = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = [pkgs.radarr];
  };
}
