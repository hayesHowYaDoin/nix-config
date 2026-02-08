{
  flake.modules.homeManager.oh-my-posh = {pkgs, ...}: {
    home.packages = with pkgs; [oh-my-posh];
  };
}
