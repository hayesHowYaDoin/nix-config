{
  den.aspects.immich.nixos = {
    services.immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      mediaLocation = "/mnt/d/media/pictures";
    };

    users.groups.users.members = ["immich"];

    systemd.services.immich-server.serviceConfig = {
      ReadWritePaths = ["/mnt/d/media/pictures"];
    };
    systemd.services.immich-machine-learning.serviceConfig = {
      ReadWritePaths = ["/mnt/d/media/pictures"];
    };

    networking.firewall.allowedTCPPorts = [2283];
  };
}
