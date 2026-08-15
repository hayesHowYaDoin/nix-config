{
  den.aspects.neovim.provides.lsp = {
    vim = {pkgs, ...}: {
      config = {
        lsp = {
          enable = true;
          lspkind.enable = true;
          lightbulb.enable = true;
          trouble.enable = true;
          # lspSignature.enable = true; Managed by blink-cmp
        };

        keymaps = [
          {
            mode = "n";
            key = "gd";
            action = "<cmd>lua vim.lsp.buf.definition()<CR>";
            silent = true;
            desc = "Go to definition";
          }
          {
            mode = "n";
            key = "gD";
            action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
            silent = true;
            desc = "Go to declaration";
          }
          {
            mode = "n";
            key = "gr";
            action = "<cmd>lua vim.lsp.buf.references()<CR>";
            silent = true;
            desc = "List references";
          }
          {
            mode = "n";
            key = "gi";
            action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
            silent = true;
            desc = "List implementations";
          }
          {
            mode = "n";
            key = "K";
            action = "<cmd>lua vim.lsp.buf.hover()<CR>";
            silent = true;
            desc = "Hover";
          }
          {
            mode = "n";
            key = "<leader>ca";
            action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
            silent = true;
            desc = "Code action";
          }
          {
            mode = "n";
            key = "<leader>th";
            action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
            silent = true;
            desc = "Toggle inlay hints";
          }
          {
            mode = "n";
            key = "<leader>fm";
            action = "<cmd>lua vim.lsp.buf.format()<CR>";
            silent = true;
            desc = "Format buffer";
          }
        ];

        extraPlugins.inlay-hints-autocmd = {
          package = pkgs.vimPlugins.nvim-lspconfig;
          setup = ''
            vim.api.nvim_create_autocmd("LspAttach", {
              group = vim.api.nvim_create_augroup("UserLspConfig", {}),
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.server_capabilities.inlayHintProvider then
                  vim.lsp.inlay_hint.enable(true, {bufnr = args.buf})
                end
              end,
            })
          '';
        };
      };
    };
  };
}
