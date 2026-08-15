{
  den.aspects.neovim.provides.transparent = {transparent ? false, ...}: {
    vim = {
      lib,
      pkgs,
      ...
    }: {
      config.extraPlugins.transparent-background = lib.mkIf transparent {
        package = pkgs.vimPlugins.base16-nvim;
        setup = ''
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
          vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
          vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
        '';
      };
    };
  };
}
