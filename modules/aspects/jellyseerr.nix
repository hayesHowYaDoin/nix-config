{
  den.aspects.jellyseerr.nixos = {
    services.seerr = {
      enable = true;
      openFirewall = true;
    };
  };
}
