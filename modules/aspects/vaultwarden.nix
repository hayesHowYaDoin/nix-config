{
  den.aspects.vaultwarden = {
    dataDir ? "/var/lib/vaultwarden",
    port ? 8222,
    domain ? null,
    signupsAllowed ? true,
    den,
    ...
  }: {
    includes = [
      (den.aspects.tailscale-serve {
        name = "vaultwarden";
        inherit port;
      })
    ];

    nixos = {config, ...}: {
      services.vaultwarden = {
        enable = true;
        config = {
          DATA_FOLDER = dataDir;
          DOMAIN =
            if domain != null
            then domain
            else "https://${config.networking.hostName}.zeedonk-eagle.ts.net";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = port;
          SIGNUPS_ALLOWED = signupsAllowed;
        };
      };

      systemd.services.vaultwarden.serviceConfig = {
        ReadWritePaths = [dataDir];
      };

      networking.firewall.allowedTCPPorts = [port];
    };
  };
}
