{
  den.aspects.default-shell.nixos = {self', ...}: {
    environment.systemPackages = [
      self'.packages.zsh
      self'.packages.nushell
    ];

    users.defaultUserShell = self'.packages.zsh;
  };
}
