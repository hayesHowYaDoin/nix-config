{
  den.aspects.home-assistant.nixos = {pkgs, ...}: let
    hacs = pkgs.fetchzip {
      url = "https://github.com/hacs/integration/releases/download/2.0.1/hacs.zip";
      sha256 = "sha256-eKTdksAKEU07y9pbHmTBl1d8L25eP/Y4VlYLubQRDmo=";
      stripRoot = false;
    };
  in {
    services.home-assistant = {
      enable = true;

      extraComponents = [
        "met"
        "esphome"
        "mqtt"
        "zeroconf"
        "bluetooth"
        "lg_thinq"
        "sharkiq"
        "ring"
        "androidtv_remote"
        "litterrobot"
      ];

      extraPackages = python3Packages:
        with python3Packages; [
          gtts
          radios
          isal
          zlib-ng
          aiogithubapi
        ];

      config = {
        default_config = {};
      };
    };

    networking.firewall.allowedTCPPorts = [8123];

    system.activationScripts.hacsInstall = {
      text = ''
        HASS_CONFIG="/var/lib/hass"
        CUSTOM_COMPONENTS="$HASS_CONFIG/custom_components"

        mkdir -p "$CUSTOM_COMPONENTS"
        rm -rf "$CUSTOM_COMPONENTS/hacs"

        if [ -d "${hacs}/hacs" ]; then
          echo "Found HACS at ${hacs}/hacs"
          cp -r ${hacs}/hacs "$CUSTOM_COMPONENTS/"
        elif [ -f "${hacs}/manifest.json" ]; then
          echo "Found HACS files directly in ${hacs}"
          mkdir -p "$CUSTOM_COMPONENTS/hacs"
          cp -r ${hacs}/* "$CUSTOM_COMPONENTS/hacs/"
        else
          echo "ERROR: Could not find HACS files in expected location"
          echo "Contents of ${hacs}:"
          ls -la ${hacs}/
          exit 1
        fi

        chown -R hass:hass "$CUSTOM_COMPONENTS"
        chmod -R 755 "$CUSTOM_COMPONENTS"
      '';
      deps = [];
    };
  };
}
