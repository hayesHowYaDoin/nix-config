{
  den.aspects.prowlarr = {den, ...}: {
    includes = [
      (den.aspects.vpn-namespaced {
        name = "prowlarr";
        port = 9696;
        execCommand = pkgs: "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=/home/jordan/.config/Prowlarr";
        extraEnv.DOTNET_SYSTEM_NET_DISABLEIPV6 = "1";
      })
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.prowlarr];

      networking.firewall.allowedTCPPorts = [9696];

      system.activationScripts.prowlarr-config = {
        text = ''
          mkdir -p /home/jordan/.config/Prowlarr
          chown jordan:users /home/jordan/.config/Prowlarr
          chmod 755 /home/jordan/.config/Prowlarr
        '';
        deps = [];
      };
    };
  };
}
