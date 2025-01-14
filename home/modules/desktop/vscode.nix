{ config, lib, pkgs, user, ... }:

with lib; let
  cfg = config.features.desktop.vscode;
in
{
  options.features.desktop.vscode.enable = mkEnableOption "VSCode configuration";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = [
        pkgs.vscode-extensions.bbenoist.nix
        pkgs.vscode-extensions.github.copilot
        pkgs.vscode-extensions.github.copilot-chat
        pkgs.vscode-extensions.kamikillerto.vscode-colorize
        pkgs.vscode-extensions.ms-azuretools.vscode-docker
        pkgs.vscode-extensions.ms-vscode-remote.remote-containers
      ];
      userSettings = {
        "editor.fontLigatures" = false;
        "git.openRepositoryInParentFolders" = "never";
        "colorize.include" = [ "*" ];
        "security.workspace.trust.untrustedFiles" = "open";
        "terminal.integrated.enableImages" = true;
      };
    };
  };
}
