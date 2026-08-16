{
  den.aspects.vaultwarden.nixos = {config, ...}: {
    services.vaultwarden = {
      enable = true;
      config = {
        DATA_FOLDER = "/mnt/d/.services/vaultwarden";
        DOMAIN = "https://${config.networking.hostName}.zeedonk-eagle.ts.net";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = true;
      };
    };

    systemd.services.vaultwarden.serviceConfig = {
      ReadWritePaths = ["/mnt/d/.services/vaultwarden"];
    };

    networking.firewall.allowedTCPPorts = [8222];
  };
}
