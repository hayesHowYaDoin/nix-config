{
  den.aspects.neovim.provides.gruvbox-material = {
    theme ? "catppuccin",
    themeStyle ? "medium",
    transparent ? false,
    ...
  }: {
    vim = {
      lib,
      pkgs,
      ...
    }: {
      config.extraPlugins.gruvbox-material = lib.mkIf (theme == "gruvbox-material") {
        package = pkgs.vimPlugins.gruvbox-material;
        setup = ''
          vim.g.gruvbox_material_background = '${themeStyle}'
          vim.g.gruvbox_material_better_performance = 1
          ${lib.optionalString transparent "vim.g.gruvbox_material_transparent_background = 1"}
          vim.cmd('colorscheme gruvbox-material')
        '';
      };
    };
  };
}
