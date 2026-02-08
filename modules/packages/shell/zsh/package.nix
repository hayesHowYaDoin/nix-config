{self, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (self.lib) wrapPackage;
    themeFile = config.shell.oh-my-posh.themeFiles.zsh;

    zshrc = pkgs.writeText "zshrc" ''
      # Add zsh-completions to fpath (before compinit)
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions

      # Initialize completion system
      autoload -Uz compinit && compinit

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

      # Plugins (fzf-tab after compinit, syntax-highlighting must be last)
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';

    zdotdir = pkgs.runCommand "zdotdir" {} ''
      mkdir -p $out
      ln -s ${zshrc} $out/.zshrc
    '';
  in {
    shell.oh-my-posh.themes.zsh = {
      theme = "pristine";
      colors = "primaries";
      sigil = "★ ";
    };

    packages.zsh = wrapPackage {
      inherit pkgs;
      package = pkgs.zsh;
      runtimeDependencies = with pkgs; [
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
      envs = {
        ZDOTDIR = builtins.toString zdotdir;
      };
      flags = [
        "-d"
      ];
    };
  };
}
