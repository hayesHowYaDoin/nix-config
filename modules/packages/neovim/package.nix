{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.neovim = config.den.lib.nvf.package pkgs config.den.aspects.neovim {
      theme = "gruvbox-material";
      themeStyle = "medium";
      transparent = true;
    };
  };
}
