{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./helix.nix
    ./neofetch.nix
    ./zsh.nix
  ];
  
  home.packages = with pkgs; [
    chafa
    coreutils
    direnv
    devenv
    fd
    fzf
    neovim
    nitch
    nvtopPackages.full
    oh-my-posh
    ripgrep
    tldr
    tmux
    usbutils
    zip
    zoxide
  ];
}
