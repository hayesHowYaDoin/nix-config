{
  den.aspects.calibre = {den, ...}: {
    includes = [
      (den.aspects.tailscale-funnel {
        name = "calibre";
        port = 8083;
        httpsPort = 8443;
      })
    ];

    nixos = {pkgs, ...}: {
      services.calibre-web = {
        enable = true;
        listen.ip = "0.0.0.0";
        listen.port = 8083;
        options = {
          calibreLibrary = "/mnt/d/media/books";
          enableBookUploading = true;
          enableBookConversion = true;
        };
      };

      environment.systemPackages = [pkgs.calibre];

      users.groups.users.members = ["calibre-web"];

      networking.firewall.allowedTCPPorts = [8083];
    };
  };
}
