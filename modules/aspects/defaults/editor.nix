{
  den.aspects.default-editor.nixos = {pkgs, ...}: {
    environment.systemPackages = [pkgs.neovim];
    environment.variables.EDITOR = "nvim";
  };
}
