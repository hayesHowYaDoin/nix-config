{
  den.aspects.dashboard = {
    # attrset: category name -> list of service entries
    # each service: { name; port; icon ? "..."; description ? "..."; scheme ? "http"; useTailnet ? false; externalPort ? null; }
    services ? {},
    tailnetDomain ? null,
    port ? 3000,
    headerStyle ? "boxed",
    widgets ? [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
    ],
    bookmarks ? [],
    customJS ? "",
    customCSS ? "",
    allowedHosts ? "*",
    ...
  }: {
    name = "dashboard";
    nixos = {config, ...}: let
      host = config.networking.hostName;

      mkHref = service: let
        scheme = service.scheme or "http";
        useTailnet = service.useTailnet or false;
        p = service.externalPort or service.port;
        hostname =
          if useTailnet && tailnetDomain != null
          then "${host}.${tailnetDomain}"
          else host;
      in "${scheme}://${hostname}:${toString p}";

      mkService = service: {
        ${service.name} = {
          description = service.description or "";
          href = mkHref service;
          icon = service.icon or "";
        };
      };

      renderedServices =
        map (categoryName: {
          ${categoryName} = map mkService services.${categoryName};
        })
        (builtins.attrNames services);
    in {
      services.homepage-dashboard = {
        enable = true;
        listenPort = port;
        inherit allowedHosts;

        settings = {
          inherit headerStyle;
        };

        inherit bookmarks widgets customJS customCSS;
        services = renderedServices;
      };
    };
  };
}
