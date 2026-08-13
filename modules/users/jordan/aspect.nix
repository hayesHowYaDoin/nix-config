{den, ...}: {
  den.aspects.jordan = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.aspects.git
      den.aspects.zsh
      den.aspects.nushell
      den.aspects.neovim
    ];

    nixos = {self', ...}: {
      users.users.jordan = {
        description = "jordan";
        extraGroups = ["dialout"];
        shell = self'.packages.zsh;
      };
    };

    homeManager = {pkgs, ...}: {
      shell.git = {
        name = "hayesHowYaDoin";
        email = "jordanhayes98@gmail.com";
      };

      home.packages = with pkgs; [
        bat
        caligula
        chafa
        coreutils
        devenv
        direnv
        dust
        eza
        fastmod
        fd
        fzf
        htop
        impala
        lazygit
        nitch
        nvtopPackages.full
        oh-my-posh
        presenterm
        ripgrep
        tldr
        tmux
        typst
        usbutils
        xclip
        yazi
        zip
        zoxide
      ];
    };
  };
}
