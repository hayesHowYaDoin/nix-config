{
  den.aspects.remote-deploy.nixos = {
    services.openssh.enable = true;
    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = ["root" "@wheel"];
  };
}
