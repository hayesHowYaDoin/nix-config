{
  den.aspects.flaresolverr.nixos = {pkgs, ...}: {
    services.flaresolverr = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = [pkgs.flaresolverr];
  };
}
