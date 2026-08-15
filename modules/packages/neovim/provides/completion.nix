{
  den.aspects.neovim.provides.completion = {
    vim.config.autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      setupOpts = {
        keymap.preset = "default";
        completion.documentation.auto_show = true;
        signature.enabled = true;
      };
      sourcePlugins = {
        emoji.enable = true;
        ripgrep.enable = true;
      };
    };
  };
}
