{
  den.aspects.default-editor.nixos = {self', ...}: {
    environment.systemPackages = [
      self'.packages.neovim
    ];

    environment.variables.EDITOR = "nvim";
  };
}
