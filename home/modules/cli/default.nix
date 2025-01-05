{ pkgs, ... }:

{
  imports = [
    ./containers.nix
    ./git.nix
  ];
}