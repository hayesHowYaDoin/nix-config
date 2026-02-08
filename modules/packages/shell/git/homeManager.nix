{
  flake.modules.homeManager.git = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.shell.git;
    in {
      options.shell.git = {
        userName = mkOption {
          type = types.str;
          example = "hayesHowYaDoin";
          description = "User name associated with the desired git account.";
        };

        userEmail = mkOption {
          type = types.str;
          example = "jordanhayes98@gmail.com";
          description = "User email associated with the desired git account.";
        };
      };

      config = {
        programs.git = {
          enable = true;
          lfs.enable = true;
          inherit (cfg) userName;
          inherit (cfg) userEmail;
        };
      };
    };
}
