{
  den.aspects.neovim.provides.dashboard = {
    vim.config = {
      utility.snacks-nvim.setupOpts.dashboard.enabled = false;

      dashboard.dashboard-nvim = {
        enable = true;
        setupOpts = {
          theme = "doom";
          config = {
            vertical_center = true;
            header = [
              ""
              "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
              "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
              "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
              "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
              "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
              ""
            ];
            center = [
              {
                icon = "󰈞  ";
                desc = "Find Files";
                action = "FzfLua files";
                key = "f";
                keymap = " ff";
              }
              {
                icon = "󰋚  ";
                desc = "Recent Files";
                action = "FzfLua oldfiles";
                key = "r";
                keymap = " fr";
              }
              {
                icon = "󰱽  ";
                desc = "Live Grep";
                action = "FzfLua live_grep";
                key = "g";
                keymap = " fg";
              }
              {
                icon = "⌘ ";
                desc = "Commands";
                action = "FzfLua commands";
                key = "c";
                keymap = " fc";
              }
              {
                icon = "󰈆  ";
                desc = "Quit";
                action = "qa";
                key = "q";
                keymap = " q";
              }
            ];
            footer = [];
          };
        };
      };
    };
  };
}
