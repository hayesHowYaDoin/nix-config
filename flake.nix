{
  description = "Nix overlays";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    budgetviz.url = "github:hayesHowYaDoin/budgetviz";
    nvim-config.url = "github:hayesHowYaDoin/nvim_config";
    wheel-wizard-nix.url = "github:hayesHowYaDoin/wheel-wizard-nix";
  };

  outputs = inputs @ {
    flake-parts,
    import-tree,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        (import-tree ./modules)
      ];
    };
}
