{
  flake.modules.nixos.staging-configuration = {
    networking.hostName = "staging";
    networking.useDHCP = true;
  };
}
