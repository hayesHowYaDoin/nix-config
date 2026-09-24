{
  hayes.hyprlock.homeManager = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          grace = 2;
          disable_loading_bar = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
            contrast = 0.9;
            brightness = 0.8;
          }
        ];

        input-field = [
          {
            size = "300, 50";
            position = "0, -80";
            halign = "center";
            valign = "center";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.35;
            outer_color = "rgba(89b4faee)";
            inner_color = "rgba(1e1e2ecc)";
            font_color = "rgba(cdd6f4ff)";
            placeholder_text = "<i>password...</i>";
            fade_on_empty = false;
          }
        ];

        label = [
          {
            text = "cmd[update:1000] date +\"%H:%M\"";
            font_size = 96;
            font_family = "JetBrainsMono Nerd Font";
            color = "rgba(cdd6f4ff)";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
