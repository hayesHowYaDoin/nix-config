{
  den.aspects.byparr = {
    port ? 8191,
    ...
  }: {
    name = "byparr";
    nixos = {
      virtualisation.oci-containers = {
        backend = "podman";
        containers.byparr = {
          image = "ghcr.io/thephaseless/byparr:latest";
          autoStart = true;
          ports = ["${toString port}:8191"];
        };
      };

      networking.firewall.allowedTCPPorts = [port];
    };
  };
}
