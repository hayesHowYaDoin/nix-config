{
  hayes.obsidian = {
    nixGL ? false,
    ...
  }: {
    homeManager = {
      config,
      lib,
      pkgs,
      ...
    }: let
      obsidianNoSandbox = pkgs.writeShellScriptBin "obsidian" ''
        exec ${pkgs.obsidian}/bin/obsidian --no-sandbox "$@"
      '';
      wrappedObsidian = config.lib.nixGL.wrap obsidianNoSandbox;
    in {
      home.packages = [
        (
          if nixGL
          then wrappedObsidian
          else pkgs.obsidian
        )
      ];

      xdg.desktopEntries.obsidian = lib.mkIf nixGL {
        name = "Obsidian";
        genericName = "Note Taking";
        exec = "${wrappedObsidian}/bin/obsidian";
        terminal = false;
        categories = ["Office" "TextEditor"];
        icon = "obsidian";
      };
    };
  };
}
