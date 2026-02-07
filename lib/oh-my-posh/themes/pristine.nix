{
  colors,
  sigil,
  ...
}: {
  "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
  version = 3;
  final_space = true;
  blocks = [
    {
      alignment = "left";
      type = "prompt";
      segments = [
        {
          foreground = colors.primary;
          style = "plain";
          template = "{{ .HostName }}";
          type = "session";
        }
        {
          foreground = colors.secondary;
          style = "plain";
          template = " {{ .Path }}";
          type = "path";
          properties = {
            style = "full";
          };
        }
      ];
    }
    {
      alignment = "left";
      type = "prompt";
      segments = [
        {
          type = "git";
          style = "plain";
          foreground = colors.tertiary;
          template = " {{ if .Working.Changed }}●{{ .HEAD }}{{ else }}{{ .HEAD }}{{ end }}";
          properties = {
            fetch_stash_count = true;
            fetch_upstream_icon = true;
            branch_icon = "";
          };
        }
      ];
    }
    {
      type = "prompt";
      alignment = "left";
      newline = true;
      segments = [
        {
          type = "status";
          style = "plain";
          template = "${sigil} ";
          foreground_templates = [
            "{{ if gt .Code 0 }}${colors.error}{{ else }}${colors.success}{{ end }}"
          ];
          properties = {
            always_enabled = true;
          };
        }
      ];
    }
  ];
  transient_prompt = {
    # template = "★ ";
    template = "${sigil} ";
    foreground_templates = [
      "{{ if gt .Code 0 }}${colors.error}{{ else }}${colors.success}{{ end }}"
    ];
  };
}
