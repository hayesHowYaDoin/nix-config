{
  flake.homeModules.shell = {pkgs, ...}: {
    home.packages = with pkgs; [oh-my-posh];
  };
}
