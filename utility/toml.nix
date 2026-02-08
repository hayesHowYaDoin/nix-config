{pkgs}: {
  fmt = pkgs.formats.toml {};
  generate = (pkgs.formats.toml {}).generate;
}
