{
  flake.modules.nixos.sops = {
    inputs,
    self,
    ...
  }: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = {
      defaultSopsFile = "${self}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age.keyFile = "/var/lib/sops-nix/key.txt";
    };
  };
}
