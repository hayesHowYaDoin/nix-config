{den, ...}: {
  den.aspects.calibre = {
    libraryPath,
    port ? 8083,
    tailscalePort ? null,
    ...
  }: {
    includes =
      [
        (den.aspects.tailscale-funnel {
          name = "calibre";
          inherit port;
          httpsPort =
            if tailscalePort != null
            then tailscalePort
            else 8443;
        })
      ];

    nixos = {pkgs, ...}: {
      services.calibre-web = {
        enable = true;
        listen.ip = "0.0.0.0";
        listen.port = port;
        options = {
          calibreLibrary = libraryPath;
          enableBookUploading = true;
          enableBookConversion = true;
        };
      };

      environment.systemPackages = [pkgs.calibre];

      users.groups.users.members = ["calibre-web"];

      networking.firewall.allowedTCPPorts = [port];
    };
  };
}
