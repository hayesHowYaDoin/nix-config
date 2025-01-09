{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./neofetch.nix
    ./zsh.nix
  ];
  
  home.packages = with pkgs; [
    chafa
    coreutils
    exiftool
    fd
    fzf
    neovim
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