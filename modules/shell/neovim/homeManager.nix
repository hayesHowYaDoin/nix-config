{
  flake.aspects.editor.neovim.homeManager = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.shell.neovim;
      supportedThemes = builtins.concatStringsSep ", " (import self + "/lib/shell/neovim/nvfThemes.nix");
    in {
      options.shell.neovim = {
        enable = mkEnableOption "custom Neovim configuration";

        theme = mkOption {
          type = types.nullOr (types.submodule {
            options = {
              name = mkOption {
                type = types.str;
                description = ''
                  Theme name. Supported nvf built-in themes: ${supportedThemes};
                '';
              };

              style = mkOption {
                type = types.str;
                default = "";
                description = "Theme style / variant.";
              };
            };
          });
          default = null;
        };

        colorScheme = mkOption {
          type = types.nullOr types.attrs;
          default = null;
          description = "nix-colors colorscheme for Neovim.";
        };

        transparentBackground =
          mkEnableOption "transparent background for Neovim";

        obsidian = mkOption {
          type = types.nullOr (types.submodule {
            options = {
              vaultPath = mkOption {
                type = types.str;
                default = "~/notes";
              };

              dailyNotesFolder = mkOption {
                type = types.str;
                default = "daily";
              };

              templatesFolder = mkOption {
                type = types.str;
                default = "templates";
              };
            };
          });
          default = null;
        };
      };

      config = mkIf cfg.enable {
        home.packages = [
          pkgs.nvim-config
        ];
      };
    };
}
