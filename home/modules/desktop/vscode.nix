{ config, lib, pkgs, user, ... }:

with lib;
let cfg = config.features.desktop.vscode;
in {
  options.features.desktop.vscode.enable =
    mkEnableOption "VSCode configuration";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        mkhl.direnv
        github.copilot
        github.copilot-chat
        jnoortheen.nix-ide
        kamikillerto.vscode-colorize
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        vadimcn.vscode-lldb
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
