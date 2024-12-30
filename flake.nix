{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, nix-colors, ... } @ inputs: 
  let
    # Supported systems
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    theme = nix-colors.colorSchemes.dracula;
    user = {
      name = "jordan";
      home = "/home/jordan";
      fullName = "Jordan Hayes";
      email = "jordanhayes98@gmail.com";
    };
  in {
    # packages = forAllSystems(system: import ./pkgs nixpkgs.legacyPackages.${system});
    # formatter = forAllSystems(system: nixpkgs.legacyPackages.${system}.alejandra);

    # nixosModules = import ./modules/nixos;
    # homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoints
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/hosts/default/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "${user.name}@default" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # home-manager requires 'pkgs' instance
        
        extraSpecialArgs = { inherit inputs user; };
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
