{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.46.2";

    hyprland-plugin = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
    };

    slippi.url = "github:lytedev/slippi-nix";

    stylix = {
      url = "github:danth/stylix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    hyprland,
    hyprtasking,
    nixpkgs,
    slippi,
    stylix,
    ...
  }@inputs: 
  let
    # Supported systems
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    
    user = {
      name = "jordan";
      home = "/home/jordan";
      fullName = "Jordan Hayes";
      email = "jordanhayes98@gmail.com";
      gitUser = "hayesHowYaDoin";
    };
  in {
    # NixOS configuration entrypoints
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs user; };
        modules = [
          ./hosts/desktop/configuration.nix
          stylix.nixosModules.stylix
          slippi.nixosModules.default
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "${user.name}@desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs user pkgs; };
        modules = [
          ./home/home.nix
          stylix.homeManagerModules.stylix
          slippi.homeManagerModules.default
        ];
      };
    };
  };
}
