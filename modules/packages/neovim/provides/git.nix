{
  den.aspects.neovim.provides.git = {
    vim.config = {
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          lazygit.enabled = true;
          gh.enabled = true;
          picker.enabled = true;
        };
      };

      git.gitsigns = {
        enable = true;
        setupOpts = {
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 300;
            ignore_whitespace = false;
          };
          current_line_blame_formatter = "<author>, <author_time:%R> • <summary>";
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>gg";
          action = "<cmd>lua Snacks.lazygit()<CR>";
          silent = true;
          desc = "Lazygit";
        }
        {
          mode = "n";
          key = "<leader>gb";
          action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
          silent = true;
          desc = "Git blame line";
        }
        {
          mode = "n";
          key = "<leader>gB";
          action = "<cmd>lua Snacks.git.blame_line()<CR>";
          silent = true;
          desc = "Git blame line (popup)";
        }
        {
          mode = "n";
          key = "<leader>gp";
          action = "<cmd>lua Snacks.picker.gh_pr()<CR>";
          silent = true;
          desc = "GitHub PRs";
        }
        {
          mode = "n";
          key = "<leader>gd";
          lua = true;
          action = ''
            function()
              local pr = vim.fn.trim(vim.fn.system("gh pr view --json number -q .number 2>/dev/null"))
              if vim.v.shell_error == 0 and pr ~= "" then
                Snacks.picker.gh_diff({ pr = tonumber(pr) })
              else
                vim.notify("No PR for current branch", vim.log.levels.WARN, { title = "gh_diff" })
              end
            end
          '';
          silent = true;
          desc = "Current PR diff";
        }
      ];
    };
  };
}
