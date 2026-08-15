{
  den.aspects.neovim.provides.languages = {
    vim.config.languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix = {
        enable = true;
        format.type = ["alejandra"];
        lsp.servers = ["nixd"];
        extraDiagnostics.types = ["statix" "deadnix"];
      };

      python = {
        enable = true;
        lsp.servers = ["basedpyright"];
        format.type = ["ruff"];
      };

      rust = {
        enable = true;
        extensions.rustaceanvim.enable = true;
        lsp.enable = false; # rustacianvim manages its own rust-analyzer
      };

      clang.enable = true;
      wgsl.enable = true;
      gleam.enable = true;
    };
  };
}
