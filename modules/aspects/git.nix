{
  den.aspects.git.homeManager = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.shell.git;
    in {
      options.shell.git = {
        name = mkOption {
          type = types.str;
          example = "hayesHowYaDoin";
          description = "User name associated with the desired git account.";
        };

        email = mkOption {
          type = types.str;
          example = "jordanhayes98@gmail.com";
          description = "User email associated with the desired git account.";
        };
      };

      config = {
        programs.git = {
          enable = true;
          lfs.enable = true;
          settings.user = {
            inherit (cfg) name;
            inherit (cfg) email;
          };
        };
      };
    };
}
