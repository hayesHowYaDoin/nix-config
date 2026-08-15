{
  den.aspects.neovim.provides.ui = {
    vim.config = {
      ui = {
        borders = {
          enable = true;
          globalStyle = "rounded";
        };
        colorizer.enable = true;
        illuminate.enable = true;
        noice.enable = true;
      };

      utility.snacks-nvim.setupOpts = {
        words.enabled = true;
        scroll.enabled = true;
        input.enabled = true;
      };
    };
  };
}
