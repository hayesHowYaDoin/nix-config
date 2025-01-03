{ pkgs, user, theme, ... }:

{
  home.packages = with pkgs; [
    vscodium
    vscode-extensions.bbenoist.nix
    vscode-extensions.kamikillerto.vscode-colorize
    vscode-extensions.github.copilot
    vscode-extensions.github.copilot-chat
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = [
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.kamikillerto.vscode-colorize
      pkgs.vscode-extensions.github.copilot
      pkgs.vscode-extensions.github.copilot-chat
    ];
    userSettings = {
      # "editor.fontFamily" = "'${theme.monoFontName}', 'monospace', monospace";
      "editor.fontLigatures" = false;
      # "editor.fontSize" = builtins.floor theme.monoFontSize * 16 / 12;
      "git.openRepositoryInParentFolders" = "never";
      "colorize.include" = [ "*" ];
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.integrated.enableImages" = true;
      /*
      "workbench.colorCustomizations" = {		
        "activityBar.activeBorder" = "#${theme.colorScheme.blueHex}";
        "activityBar.background" = "#${theme.colorScheme.background1Hex}";
        "activityBar.border" = "#${theme.colorScheme.background2Hex}";
        "activityBar.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "activityBar.inactiveForeground" = "#${theme.colorScheme.foreground4Hex}";
        "activityBarBadge.background" = "#${theme.colorScheme.blueHex}";
        "activityBarBadge.foreground" = "#${theme.colorScheme.foreground1Hex}";
        "badge.background" = "#${theme.colorScheme.background4Hex}";
        "badge.foreground" = "#${theme.colorScheme.foreground1Hex}";
        "button.background" = "#${theme.colorScheme.blueHex}";
        "button.border" = "#${theme.colorScheme.foreground1Hex}${theme.colorScheme.transparencyLightShadeHex}";
        "button.foreground" = "#${theme.colorScheme.foreground1Hex}";
        "button.hoverBackground" = "#${theme.colorScheme.blueHex}";
        "button.secondaryBackground" = "#${theme.colorScheme.background2Hex}";
        "button.secondaryForeground" = "#${theme.colorScheme.foreground3Hex}";
        "button.secondaryHoverBackground" = "#${theme.colorScheme.background3Hex}";
        "chat.slashCommandBackground" = "#${theme.colorScheme.background3Hex}";
        "chat.slashCommandForeground" = "#${theme.colorScheme.cyanHex}";
        "checkbox.background" = "#${theme.colorScheme.background2Hex}";
        "checkbox.border" = "#${theme.colorScheme.background3Hex}";
        "debugToolBar.background" = "#${theme.colorScheme.background1Hex}";
        "descriptionForeground" = "#${theme.colorScheme.foreground4Hex}";
        "dropdown.background" = "#${theme.colorScheme.background2Hex}";
        "dropdown.border" = "#${theme.colorScheme.background3Hex}";
        "dropdown.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "dropdown.listBackground" = "#${theme.colorScheme.background1Hex}";
        "editor.background" = "#${theme.colorScheme.background1Hex}";
        "editor.findMatchBackground" = "#${theme.colorScheme.brownHex}";
        "editor.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "editorGroup.border" = "#${theme.colorScheme.foreground1Hex}${theme.colorScheme.transparencyLightShadeHex}";
        "editorGroupHeader.tabsBackground" = "#${theme.colorScheme.background1Hex}";
        "editorGroupHeader.tabsBorder" = "#${theme.colorScheme.background2Hex}";
        "editorGutter.addedBackground" = "#${theme.colorScheme.greenHex}";
        "editorGutter.deletedBackground" = "#${theme.colorScheme.redHex}";
        "editorGutter.modifiedBackground" = "#${theme.colorScheme.blueHex}";
        "editorLineNumber.activeForeground" = "#${theme.colorScheme.foreground3Hex}";
        "editorLineNumber.foreground" = "#${theme.colorScheme.foreground4Hex}";
        "editorOverviewRuler.border" = "#${theme.colorScheme.background1Hex}";
        "editorWidget.background" = "#${theme.colorScheme.background1Hex}";
        "errorForeground" = "#${theme.colorScheme.redHex}";
        "focusBorder" = "#${theme.colorScheme.blueHex}";
        "foreground" = "#${theme.colorScheme.foreground3Hex}";
        "icon.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "input.background" = "#${theme.colorScheme.background2Hex}";
        "input.border" = "#${theme.colorScheme.background3Hex}";
        "input.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "input.placeholderForeground" = "#${theme.colorScheme.foreground4Hex}";
        "inputOption.activeBackground" = "#${theme.colorScheme.blueHex}${theme.colorScheme.transparencyBackgroundHex}";
        "inputOption.activeBorder" = "#${theme.colorScheme.blueHex}";
        "keybindingLabel.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "menu.background" = "#${theme.colorScheme.background1Hex}";
        "notificationCenterHeader.background" = "#${theme.colorScheme.background1Hex}";
        "notificationCenterHeader.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "notifications.background" = "#${theme.colorScheme.background1Hex}";
        "notifications.border" = "#${theme.colorScheme.background2Hex}";
        "notifications.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "panel.background" = "#${theme.colorScheme.background1Hex}";
        "panel.border" = "#${theme.colorScheme.background2Hex}";
        "panelInput.border" = "#${theme.colorScheme.background2Hex}";
        "panelTitle.activeBorder" = "#${theme.colorScheme.blueHex}";
        "panelTitle.activeForeground" = "#${theme.colorScheme.foreground3Hex}";
        "panelTitle.inactiveForeground" = "#${theme.colorScheme.foreground4Hex}";
        "peekViewEditor.background" = "#${theme.colorScheme.background1Hex}";
        "peekViewEditor.matchHighlightBackground" = "#${theme.colorScheme.yellowHex}${theme.colorScheme.transparencyHeavyShadeHex}";
        "peekViewResult.background" = "#${theme.colorScheme.background1Hex}";
        "peekViewResult.matchHighlightBackground" = "#${theme.colorScheme.yellowHex}${theme.colorScheme.transparencyHeavyShadeHex}";
        "pickerGroup.border" = "#${theme.colorScheme.background3Hex}";
        "progressBar.background" = "#${theme.colorScheme.blueHex}";
        "quickInput.background" = "#${theme.colorScheme.background1Hex}";
        "quickInput.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "settings.dropdownBackground" = "#${theme.colorScheme.background2Hex}";
        "settings.dropdownBorder" = "#${theme.colorScheme.background3Hex}";
        "settings.headerForeground" = "#${theme.colorScheme.foreground1Hex}";
        "settings.modifiedItemIndicator" = "#${theme.colorScheme.yellowHex}${theme.colorScheme.transparencyHeavyShadeHex}";
        "sideBar.background" = "#${theme.colorScheme.background1Hex}";
        "sideBar.border" = "#${theme.colorScheme.background2Hex}";
        "sideBar.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "sideBarSectionHeader.background" = "#${theme.colorScheme.background1Hex}";
        "sideBarSectionHeader.border" = "#${theme.colorScheme.background2Hex}";
        "sideBarSectionHeader.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "sideBarTitle.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "statusBar.background" = "#${theme.colorScheme.background1Hex}";
        "statusBar.border" = "#${theme.colorScheme.background2Hex}";
        "statusBar.debuggingBackground" = "#${theme.colorScheme.blueHex}";
        "statusBar.debuggingForeground" = "#${theme.colorScheme.foreground1Hex}";
        "statusBar.focusBorder" = "#${theme.colorScheme.blueHex}";
        "statusBar.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "statusBar.noFolderBackground" = "#${theme.colorScheme.background1Hex}";
        "statusBarItem.focusBorder" = "#${theme.colorScheme.blueHex}";
        "statusBarItem.prominentBackground" = "#${theme.colorScheme.background4Hex}";
        "statusBarItem.remoteBackground" = "#${theme.colorScheme.blueHex}";
        "statusBarItem.remoteForeground" = "#${theme.colorScheme.foreground1Hex}";
        "tab.activeBackground" = "#${theme.colorScheme.background1Hex}";
        "tab.activeBorder" = "#${theme.colorScheme.background1Hex}";
        "tab.activeBorderTop" = "#${theme.colorScheme.blueHex}";
        "tab.activeForeground" = "#${theme.colorScheme.foreground1Hex}";
        "tab.border" = "#${theme.colorScheme.background2Hex}";
        "tab.hoverBackground" = "#${theme.colorScheme.background1Hex}";
        "tab.inactiveBackground" = "#${theme.colorScheme.background1Hex}";
        "tab.inactiveForeground" = "#${theme.colorScheme.foreground4Hex}";
        "tab.unfocusedActiveBorder" = "#${theme.colorScheme.background1Hex}";
        "tab.unfocusedActiveBorderTop" = "#${theme.colorScheme.background2Hex}";
        "tab.unfocusedHoverBackground" = "#${theme.colorScheme.background1Hex}";
        "terminal.foreground" = "#${theme.colorScheme.foreground3Hex}";
        "terminal.tab.activeBorder" = "#${theme.colorScheme.blueHex}";
        "textBlockQuote.background" = "#${theme.colorScheme.background2Hex}";
        "textBlockQuote.border" = "#${theme.colorScheme.background4Hex}";
        "textCodeBlock.background" = "#${theme.colorScheme.background2Hex}";
        "textLink.activeForeground" = "#${theme.colorScheme.cyanHex}";
        "textLink.foreground" = "#${theme.colorScheme.cyanHex}";
        "textSeparator.foreground" = "#${theme.colorScheme.background2Hex}";
        "titleBar.activeBackground" = "#${theme.colorScheme.background1Hex}";
        "titleBar.activeForeground" = "#${theme.colorScheme.foreground3Hex}";
        "titleBar.border" = "#${theme.colorScheme.background2Hex}";
        "titleBar.inactiveBackground" = "#${theme.colorScheme.background1Hex}";
        "titleBar.inactiveForeground" = "#${theme.colorScheme.foreground4Hex}";
        "welcomePage.tileBackground" = "#${theme.colorScheme.background2Hex}";
        "welcomePage.progress.foreground" = "#${theme.colorScheme.blueHex}";
        "widget.border" = "#${theme.colorScheme.background2Hex}";
      };
    */
    };
  };
}
