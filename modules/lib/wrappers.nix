_: {
  flake.lib.wrapPackage = {
    pkgs,
    package,
    runtimeDependencies ? [],
    envs ? {},
    flags ? [],
  }: let
    packageName = package.pname or package.name;
    binaryName = package.NIX_MAIN_PROGRAM or packageName;
    prefixesMap = "--prefix PATH : ${pkgs.lib.makeBinPath runtimeDependencies}";
    setsMap = builtins.map (name: "--set ${name} ${envs.${name}}") (builtins.attrNames envs);
    flagsMap = builtins.map (f:
      if builtins.isString f
      then ''--add-flags "${f}"''
      else ''--add-flags "${f.name} ${f.value}"'')
    flags;

    postBuild =
      ''
        rm $out/bin/${binaryName}
        makeWrapper ${package}/bin/${binaryName} $out/bin/${binaryName} \
      ''
      + "${prefixesMap} \\\n"
      + builtins.concatStringsSep " \\\n" setsMap
      + (
        if setsMap != []
        then " \\\n"
        else ""
      )
      + builtins.concatStringsSep " \\\n" flagsMap;
  in
    pkgs.symlinkJoin {
      name = "${packageName}-wrapped";
      paths = [package];
      meta.mainProgram = "${binaryName}";
      nativeBuildInputs = [pkgs.makeWrapper];
      inherit postBuild;
    };
}
