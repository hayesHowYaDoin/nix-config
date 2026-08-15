{
  den.aspects.neovim.provides.search = {
    vim.config = {
      fzf-lua = {
        enable = true;
        profile = "default";
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>ff";
          action = "<cmd>FzfLua files<CR>";
          silent = true;
          desc = "Find files";
        }
        {
          mode = "n";
          key = "<leader>fg";
          action = "<cmd>FzfLua live_grep<CR>";
          silent = true;
          desc = "Live grep";
        }
        {
          mode = "n";
          key = "<leader>fb";
          action = "<cmd>FzfLua buffers<CR>";
          silent = true;
          desc = "Buffers";
        }
        {
          mode = "n";
          key = "<leader>fh";
          action = "<cmd>FzfLua help_tags<CR>";
          silent = true;
          desc = "Help tags";
        }
        {
          mode = "n";
          key = "<leader>fc";
          action = "<cmd>FzfLua commands<CR>";
          silent = true;
          desc = "Commands";
        }
      ];
    };
  };
}
