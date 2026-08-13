{
  pkgs,
  nvf,
  themeConfig ? (import ./defaults/theme.nix),
  transparentBackground ? (import ./defaults/transparentBackground.nix),
  obsidianConfig ? (import ./defaults/obsidian.nix),
  colorScheme ? (import ./defaults/colorScheme.nix),
}: let
  nvimConfig = import ./config.nix {
    inherit pkgs themeConfig transparentBackground obsidianConfig;
  };
  base16Globals =
    if colorScheme != null
    then
      pkgs.lib.mapAttrs' (
        name: value:
          pkgs.lib.nameValuePair "base16_${name}" "#${value}"
      )
      colorScheme.palette
    else {};
in
  nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      {
        config.vim =
          nvimConfig
          // {
            globals = nvimConfig.globals // base16Globals;
          };
      }
    ];
  }
