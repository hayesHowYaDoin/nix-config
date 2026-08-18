{
  den.aspects.vpn-namespaced = {
    name,
    port,
    # execCommand is a function of pkgs: pkgs -> string
    # e.g. execCommand = pkgs: "${pkgs.prowlarr}/bin/Prowlarr -nobrowser ...";
    execCommand,
    user,
    extraEnv ? {},
    ...
  }: {
    name = "vpn-namespaced/${name}";
    nixos = {pkgs, ...}: {
      systemd.services.${name} = {
        description = "${name} in VPN-isolated network namespace";
        after = ["vpn-netns-setup.service"];
        requires = ["vpn-netns-setup.service"];
        bindsTo = ["vpn-netns-setup.service"];
        wantedBy = ["multi-user.target"];

        environment = extraEnv;

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.iproute2}/bin/ip netns exec vpn ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/bash ${user} -c '${execCommand pkgs}'";
          Restart = "always";
          RestartSec = "10s";
          PrivateTmp = true;
        };
      };

      systemd.services."${name}-port-forward" = {
        description = "Forward ${name} from VPN namespace to host";
        after = ["${name}.service"];
        requires = ["${name}.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "5s";
        };

        script = ''
          exec ${pkgs.socat}/bin/socat TCP-LISTEN:${toString port},fork,reuseaddr TCP:10.200.200.2:${toString port}
        '';
      };
    };
  };
}
