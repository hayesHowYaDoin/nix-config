{
  den.aspects.neovim.provides.optimizations = {
    vim.config = {
      preventJunkFiles = true;
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          bigfile.enabled = true;
          quickfile.enabled = true;
        };
      };
    };
  };
}
