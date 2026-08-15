{
  den.aspects.neovim.provides.theme = {
    theme ? "catppuccin",
    themeStyle ? "mocha",
    ...
  }: let
    nvfNativeThemes = [
      "base16"
      "catppuccin"
      "dracula"
      "everforest"
      "github"
      "gruvbox"
      "mini-base16"
      "nord"
      "onedark"
      "oxocarbon"
      "rose-pine"
      "solarized"
      "solarized-osaka"
      "tokyonight"
    ];
  in {
    vim.config.theme =
      if builtins.elem theme nvfNativeThemes
      then {
        enable = true;
        name = theme;
        style = themeStyle;
      }
      else {enable = false;};
  };
}
