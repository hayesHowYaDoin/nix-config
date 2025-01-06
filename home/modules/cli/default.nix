{ config, pkgs, ... }:

{
  imports = [
    ./containers.nix
    ./git.nix
    ./neofetch.nix
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