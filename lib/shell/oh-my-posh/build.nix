{
  config,
  name,
  theme,
  colors,
  sigil,
  ...
}: let
  colorScheme = (import (./colors + "/${colors}.nix") {inherit config;}).colors;
in {
  name = "${name}-omp-theme.json";
  text = builtins.toJSON (
    import (./themes + "/${theme}.nix") {
      inherit sigil;
      colors = colorScheme;
    }
  );
}
