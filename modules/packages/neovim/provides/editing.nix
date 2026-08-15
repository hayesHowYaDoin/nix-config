{
  den.aspects.neovim.provides.editing = {
    vim = {pkgs, ...}: {
      config = {
        utility.surround.enable = true;
        comments.comment-nvim.enable = true;

        extraPlugins.renamer-nvim = {
          package = pkgs.vimPlugins.renamer-nvim;
          setup = ''
            require('renamer').setup({
              title = 'Rename',
              padding = { top = 0, left = 0, bottom = 0, right = 0 },
              min_width = 15,
              max_width = 45,
              border = true,
              border_chars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
            })
          '';
        };

        keymaps = [
          {
            mode = "n";
            key = "<leader>rn";
            action = "<cmd>lua require('renamer').rename()<CR>";
            silent = true;
            desc = "LSP rename (renamer popup)";
          }
        ];
      };
    };
  };
}
