{
  config,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: let
    themeFile = pkgs.writeTextFile (
      import (self + "/lib/shell/oh-my-posh/build.nix") {
        inherit config;
        name = "zsh";
        theme = "pristine";
        colors = "primaries";
        sigil = "★ ";
      }
    );

    runtimeDeps = with pkgs; [
      fzf
      zoxide
      direnv
      oh-my-posh
      eza
      bat
      dust
      lazygit
      neovim
    ];

    zdotdir = pkgs.runCommand "zdotdir" {} ''
      mkdir -p $out
      ln -s ${zshrc} $out/.zshrc
    '';

    zshrc = pkgs.writeText "zshrc" ''
      # Keybinds
      bindkey -e
      bindkey '^ ' autosuggest-accept
      bindkey '^[OA' history-search-backward
      bindkey '^[OB' history-search-forward

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      # Shell integrations
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"
      eval "$(direnv hook zsh)"
      eval "$(oh-my-posh init zsh --config ${themeFile})"

      # Aliases
      alias os="sudo nixos-rebuild switch --flake"
      alias home="home-manager switch --flake"
      alias ls="eza"
      alias c="clear"
      alias v="nvim"
      alias cat="bat"
      alias du="dust"
      alias lgit="lazygit"
    '';
  in {
    packages.zsh = pkgs.symlinkJoin {
      name = "zsh-wrapped";
      paths = [pkgs.zsh];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        rm $out/bin/zsh
        makeWrapper ${pkgs.zsh}/bin/zsh $out/bin/zsh \
          --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps} \
          --set ZDOTDIR ${zdotdir} \
          --add-flags "-d"
      '';
      meta.mainProgram = "zsh";
    };
  };
}
