{
  den.aspects.samba.nixos = {config, ...}: {
    services.samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "${config.networking.hostName} Storage Server";
          "netbios name" = config.networking.hostName;

          security = "user";
          "map to guest" = "bad user";
          "guest account" = "nobody";

          "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
          "read raw" = "yes";
          "write raw" = "yes";
          "max xmit" = 65535;
          "dead time" = 15;
          "getwd cache" = "yes";

          "fruit:metadata" = "stream";
          "fruit:model" = "MacSamba";
          "fruit:posix_rename" = "yes";
          "fruit:veto_appledouble" = "no";
          "fruit:nfs_aces" = "no";
          "fruit:wipe_intentionally_left_blank_rfork" = "yes";
          "fruit:delete_empty_adfiles" = "yes";

          "log file" = "/var/log/samba/log.%m";
          "max log size" = 50;
          "log level" = 1;
        };

        media = {
          path = "/mnt/d/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "guest only" = "yes";
          "create mask" = "0775";
          "directory mask" = "0775";
          "force user" = "jordan";
          "force group" = "users";
          "vfs objects" = "fruit streams_xattr";
          comment = "Media Share";
        };

        documents = {
          path = "/mnt/d/documents";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "guest only" = "yes";
          "create mask" = "0775";
          "directory mask" = "0775";
          "force user" = "jordan";
          "force group" = "users";
          "vfs objects" = "fruit streams_xattr";
          comment = "Documents Share";
        };
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
      extraServiceFiles = {
        smb = ''
          <?xml version="1.0" standalone='no'?>
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
            <name replace-wildcards="yes">%h</name>
            <service>
              <type>_smb._tcp</type>
              <port>445</port>
            </service>
          </service-group>
        '';
      };
    };
  };
}
