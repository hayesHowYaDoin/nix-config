{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    pkgs,
    config,
    lib,
    ...
  }: {
    options.shell.oh-my-posh = {
      themes = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            theme = lib.mkOption {
              type = lib.types.str;
              default = "pristine";
              description = "Theme name (file in themes/ directory)";
            };
            colors = lib.mkOption {
              type = lib.types.str;
              default = "primaries";
              description = "Color scheme name (file in colors/ directory)";
            };
            sigil = lib.mkOption {
              type = lib.types.str;
              default = "❯ ";
              description = "Prompt sigil/symbol";
            };
          };
        });
        default = {};
        description = "Oh-my-posh theme configurations";
      };

      themeFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.package;
        readOnly = true;
        description = "Built theme files (derived from themes option)";
      };
    };

    config.shell.oh-my-posh.themeFiles = let
      flakeConfig = config;
      buildTheme = name: themeCfg: let
        colorScheme =
          (import ./_lib/colors/${themeCfg.colors}.nix {
            config = flakeConfig;
          }).colors;
        themeContent = import ./_lib/themes/${themeCfg.theme}.nix {
          inherit (themeCfg) sigil;
          colors = colorScheme;
        };
      in
        pkgs.writeTextFile {
          name = "${name}-omp-theme.json";
          text = builtins.toJSON themeContent;
        };
    in
      lib.mapAttrs buildTheme config.shell.oh-my-posh.themes;
  });
}
