{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./neofetch.nix
    ./zsh.nix
  ];
  
  home.packages = with pkgs; [
    coreutils
    btop
    fd
    fzf
    ripgrep
    tldr
    tmux
    zip
    exiftool
    chafa
    nvtopPackages.full
    zoxide
    oh-my-posh
  ];
}