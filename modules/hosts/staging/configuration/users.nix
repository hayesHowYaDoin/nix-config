{self, ...}: {
  den.aspects.staging.nixos = {
    imports = [
      self.modules.nixos.jordan
    ];

    users.users.jordan.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICx+FQoYu6ykzRxgh8h4etpw33a+D5vWXKOgHruaDUBA jordan@nixos"
    ];

    security.sudo.wheelNeedsPassword = false;
  };
}
