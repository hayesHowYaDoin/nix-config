{
  den.aspects.audiobookshelf.nixos = {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      port = 13378;
    };
  };
}
