{self, ...}: {
  flake.modules.nixos.mort-configuration = {config, ...}: {
    imports = with self.modules.nixos; [
      ssh
      network-manager
      dynamic-hostname
      sops
    ];

    sops.secrets.wifi-env = {};

    networking.dynamicHostname.prefix = "mort";

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [config.sops.secrets.wifi-env.path];
      profiles.home-wifi = {
        connection = {
          id = "home-wifi";
          type = "wifi";
          autoconnect = true;
        };
        wifi = {
          ssid = "A Wi-Fi Actually Like";
          mode = "infrastructure";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PSK";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };
  };
}
