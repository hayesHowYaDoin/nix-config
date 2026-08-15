{
  den.aspects.neovim.provides.files = {
    vim.config = {
      utility = {
        yazi-nvim.enable = true;
        diffview-nvim.enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>cw";
          action = "<cmd>Yazi cwd<CR>";
          silent = true;
          desc = "Yazi (cwd)";
        }
        {
          mode = "n";
          key = "<leader>cf";
          action = "<cmd>Yazi<CR>";
          silent = true;
          desc = "Yazi (current file's dir)";
        }
        {
          mode = "n";
          key = "<leader>dv";
          lua = true;
          action = ''
            function()
              if require("diffview.lib").get_current_view() then
                vim.cmd("DiffviewClose")
              else
                vim.cmd("DiffviewOpen")
              end
            end
          '';
          silent = true;
          desc = "Diff view (toggle)";
        }
      ];
    };
  };
}
