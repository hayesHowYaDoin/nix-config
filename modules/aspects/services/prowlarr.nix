{
  hayes.prowlarr = {
    user ? "prowlarr",
    dataDir ? "/var/lib/prowlarr",
    port ? 9696,
    ...
  }: {
    name = "prowlarr-svc/${user}";

    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.prowlarr];

      networking.firewall.allowedTCPPorts = [port];

      users.users.${user} = {
        isSystemUser = true;
        group = user;
        home = dataDir;
        createHome = true;
      };
      users.groups.${user} = {};

      systemd.services.prowlarr = {
        description = "Prowlarr (${user})";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        # .NET tries IPv6 first; on a killswitched host where v6 is blocked
        # this adds a multi-second delay to every outbound call. Disable it.
        environment.DOTNET_SYSTEM_NET_DISABLEIPV6 = "1";

        serviceConfig = {
          Type = "simple";
          User = user;
          Group = user;
          ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${dataDir}";
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };
  };
}
