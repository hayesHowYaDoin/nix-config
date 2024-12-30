{ inputs, pkgs, user, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/obsidian.nix
    ./modules/vscode.nix
  ];

  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  home.username = user.name;
  home.homeDirectory = user.home;

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Enable if not using NixOS
  # targets.genericLinux.enable = true;

  home.packages = [
    # May eventually be useful -- only install one nerd font vs. ALL of them
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
