{
  den.aspects.byparr.nixos = {
    virtualisation.oci-containers = {
      backend = "podman";
      containers.byparr = {
        image = "ghcr.io/thephaseless/byparr:latest";
        autoStart = true;
        ports = ["8191:8191"];
      };
    };

    networking.firewall.allowedTCPPorts = [8191];
  };
}
