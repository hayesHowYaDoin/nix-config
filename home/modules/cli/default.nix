{ config, pkgs, ... }:

{
  imports = [
    ./containers.nix
    ./git.nix
    ./neofetch.nix
  ];

  home.file."test".text = ''
    ${config.home.homeDirectory}
  '';

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