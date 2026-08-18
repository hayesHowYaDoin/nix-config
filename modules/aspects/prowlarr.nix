{den, ...}: {
  den.aspects.prowlarr = {
    user ? "prowlarr",
    dataDir ? "/var/lib/prowlarr",
    port ? 9696,
    ...
  }: {
    includes = [
      (den.aspects.vpn-namespaced {
        name = "prowlarr";
        inherit user port;
        execCommand = pkgs: "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${dataDir}";
        extraEnv.DOTNET_SYSTEM_NET_DISABLEIPV6 = "1";
      })
    ];

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
    };
  };
}
