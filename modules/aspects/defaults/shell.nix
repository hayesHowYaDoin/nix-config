{
  den.aspects.default-shell.nixos = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.zsh
      pkgs.nushell
    ];

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
