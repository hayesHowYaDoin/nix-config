{ inputs, pkgs, user, config, ... }:

{
  home.packages = with pkgs; [
    docker
  ];

#   users.users.${user.name}.extraGroups = [ "docker" ];
}