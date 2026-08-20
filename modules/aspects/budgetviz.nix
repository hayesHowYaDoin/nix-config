{inputs, ...}: {
  den.aspects.budgetviz.nixos = {
    imports = [inputs.budgetviz.nixosModules.default];

    services.budgetviz = {
      enable = true;
      port = 5173;
      openFirewall = true;
    };

    systemd.services.budgetviz.serviceConfig = {
      SystemCallFilter = ["@system-service" "~@privileged" "~@resources" "pkey_alloc"];
    };
  };
}
