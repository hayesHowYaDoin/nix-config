{
  flake.modules.nixos.default-user = let
    userName = "nixos";
  in {
    users.users.nixos = {
      isNormalUser = true;
      description = userName;
      initialPassword = "nixos";
      extraGroups = ["wheel"];
    };
  };
}
