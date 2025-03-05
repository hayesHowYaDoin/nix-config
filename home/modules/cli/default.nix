{ config, pkgs, ... }:

{
  imports = [ ./git.nix ./helix.nix ./neofetch.nix ./zsh.nix ];

  home.packages = with pkgs; [
    caligula
    chafa
    coreutils
    direnv
    devenv
    fd
    fzf
    htop
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
