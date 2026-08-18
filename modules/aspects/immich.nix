{
  den.aspects.immich = {
    mediaLocation,
    port ? 2283,
    ...
  }: {
    name = "immich";
    nixos = {
      services.immich = {
        enable = true;
        inherit port;
        host = "0.0.0.0";
        inherit mediaLocation;
      };

      users.groups.users.members = ["immich"];

      systemd.services.immich-server.serviceConfig = {
        ReadWritePaths = [mediaLocation];
      };
      systemd.services.immich-machine-learning.serviceConfig = {
        ReadWritePaths = [mediaLocation];
      };

      networking.firewall.allowedTCPPorts = [port];
    };
  };
}
