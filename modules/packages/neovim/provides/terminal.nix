{
  den.aspects.neovim.provides.terminal = {
    vim.config = {
      terminal.toggleterm = {
        enable = true;
        lazygit.enable = false;
        setupOpts.direction = "float";
        mappings.open = "<C-\\>";
      };
    };
  };
}
