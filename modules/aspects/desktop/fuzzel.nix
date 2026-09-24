{
  hayes.fuzzel = {
    terminal ? "ghostty",
    ...
  }: {
    homeManager = {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            inherit terminal;
            layer = "overlay";
            font = "JetBrainsMono Nerd Font:size=12";
            prompt = "'> '";
            width = 40;
            lines = 12;
            horizontal-pad = 16;
            vertical-pad = 12;
            inner-pad = 8;
          };
          colors = {
            background = "1e1e2eee";
            text = "cdd6f4ff";
            selection = "313244ff";
            selection-text = "cdd6f4ff";
            border = "89b4faff";
          };
          border = {
            width = 2;
            radius = 10;
          };
        };
      };
    };
  };
}
