_: {
  flake.lib.tomlUtils = {pkgs, ...}: {
    fmt = pkgs.formats.toml {};
    inherit ((pkgs.formats.toml {})) generate;
  };
}
