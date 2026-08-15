{
  den.aspects.neovim.provides.preferences = {
    vim.config = {
      lineNumberMode = "relNumber";
      clipboard.registers = "unnamedplus";
      options = {
        wrap = true;
        scrolloff = 8;
        termguicolors = true;
        foldenable = false;
      };
    };
  };
}
