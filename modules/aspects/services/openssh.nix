{
  hayes.openssh = {
    passwordAuthentication ? false,
    ...
  }: {
    nixos = {
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = passwordAuthentication;
      };
    };
  };
}
