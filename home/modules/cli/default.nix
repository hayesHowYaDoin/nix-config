{ config, pkgs, ... }:

{
  imports = [ ./git.nix ./helix.nix ./neofetch.nix ./zsh.nix ];

  home.packages = with pkgs; [
    bat
    caligula
    chafa
    coreutils
    devenv
    direnv
    du-dust
    eza
    fd
    fzf
    gitui
    htop
    neovim
    nitch
    nvtopPackages.full
    oh-my-posh
    presenterm
    ripgrep
    tldr
    tmux
    typst
    usbutils
    yazi
    zip
    zoxide
  ];
}
