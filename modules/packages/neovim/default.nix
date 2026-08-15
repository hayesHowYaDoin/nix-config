{den, ...}: {
  den.aspects.neovim = _ctx: {
    includes = with den.aspects.neovim.provides; [
      completion
      dashboard
      editing
      files
      git
      gruvbox-material
      languages
      leader
      lsp
      motion
      notifications
      optimizations
      preferences
      search
      statusline
      terminal
      theme
      transparent
      treesitter
      ui
    ];
  };
}
