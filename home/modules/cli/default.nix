{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./neofetch.nix
    ./zsh.nix
  ];
  
  home.packages = with pkgs; [
    coreutils
    fd
    htop
    ripgrep
    tldr
    zip
    exiftool
    chafa
    nvtopPackages.full
    zoxide
  ];
}