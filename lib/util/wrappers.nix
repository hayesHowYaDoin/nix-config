{
  wrapPackage = {
    pkgs,
    package,
    runtimeDependencies ? [],
    envs ? {},
    flags ? [],
  }: let
    packageName = package.pname or package.name;
    prefixesMap = "--prefix PATH : ${pkgs.lib.makeBinPath runtimeDependencies}";
    setsMap = builtins.map (name: "--set ${name} ${envs.${name}}") (builtins.attrNames envs);
    flagsMap = builtins.map (f:
      if builtins.isString f
      then ''--add-flags "${f}"''
      else ''--add-flags "${f.name} ${f.value}"'')
    flags;

    postBuild =
      ''
        rm $out/bin/${packageName}
        makeWrapper ${package}/bin/${packageName} $out/bin/${packageName} \
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
      meta.mainProgram = packageName;
      nativeBuildInputs = [pkgs.makeWrapper];
      inherit postBuild;
    };
}
