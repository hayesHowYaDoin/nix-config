{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    colmena = inputs.colmena.packages.${system}.colmena;
  in {
    packages.colmena = colmena;

    devShells.default = pkgs.mkShell {
      packages = [colmena];
    };
  };
}
