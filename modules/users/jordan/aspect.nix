{
  self,
  den,
  ...
}: {
  den.aspects.jordan = {
    includes = with den.batteries; [
      define-user
      primary-user
    ];

    nixos = {pkgs, ...}: {
      users.users.jordan = {
        description = "jordan";
        extraGroups = ["dialout"];
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.zsh;
      };
    };

    homeManager = {pkgs, ...}: {
      imports = [
        self.modules.homeManager.git
        self.modules.homeManager.zsh
        self.modules.homeManager.neovim
      ];

      shell.git = {
        userName = "hayesHowYaDoin";
        userEmail = "jordanhayes98@gmail.com";
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
