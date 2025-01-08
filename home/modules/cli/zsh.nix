{ config, lib, pkgs, user, ...}:

with lib; let
  cfg = config.features.cli.zsh;
  p10k_path = ../../assets/p10k.zsh;
in {
  options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Powerlevel10k theme
        [[ ! -f ${p10k_path} ]] || source ${p10k_path}
      '';

      initExtra = ''
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
      '';

      history = {
        size = 5000;
        save = 5000;
        path = "$HOME/.zsh_history";
        append = true;
        share = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
      };

      zplug = {
        enable = true;
        plugins = [
          {
            name = "romkatv/powerlevel10k";
            tags = [ "as:theme" "depth:1" ];
          }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "zsh-users/zsh-completions"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "Aloxaf/fzf-tab"; }
        ];
      };

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake";
        home = "home-manager switch --flake";
        ls = "ls --color";
        c = "clear";
      };
    };
  };

}