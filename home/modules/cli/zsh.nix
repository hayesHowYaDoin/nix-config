{ config, lib, pkgs, user, ...}:

with lib; let
  cfg = config.features.cli.zsh;
  p10k_path = ../../assets/p10k.zsh;
in {
  options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        [[ ! -f ${p10k_path} ]] || source ${p10k_path}
      '';

      zplug = {
        enable = true;
        plugins = [
          {
            name = "romkatv/powerlevel10k";
            tags = [ "as:theme" "depth:1" ];
          }
          # { name = "loiccoyle/zsh-github-copilot"; }
        ];
      };

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake";
        home = "home-manager switch --flake";
      };
    };
  };

}