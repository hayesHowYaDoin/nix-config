let
  dir = ./.;
  files = builtins.readDir dir;
  isNixFile = name:
    files.${name}
    == "regular"
    && builtins.match ".*\\.nix" name != null
    && name != "default.nix";
  nixFileNames = builtins.filter isNixFile (builtins.attrNames files);
  importFile = name: {
    name = builtins.replaceStrings [".nix"] [""] name;
    value = import (dir + "/${name}");
  };
in
  builtins.listToAttrs (map importFile nixFileNames)
