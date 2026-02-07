{config, ...}: {
  fmt = config.pkgs.formats.toml {};
  inherit (config.pkgs.formats.toml) generate;
}
